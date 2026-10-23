// Object/control event provenance contract:
// docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md
(function() {
        if (/Mac|iPhone|iPad|iPod/.test(navigator.platform || '')) {
          document.documentElement.classList.add('Pinhki-platform-mac');
        }
      })();

(function() {
        function selectizeInputForTarget(target) {
          if (!target || !target.closest) return null;
          var control = target.closest('.selectize-control');
          if (control && control.parentElement) {
            var localSelect = control.parentElement.querySelector('select');
            if (localSelect && localSelect.selectize) return localSelect;
          }
          var dropdown = target.closest('.selectize-dropdown');
          if (!dropdown) return null;
          var selects = document.querySelectorAll('select');
          for (var i = 0; i < selects.length; i++) {
            var select = selects[i];
            var instance = select && select.selectize;
            var dropdownNode = instance && instance.$dropdown && instance.$dropdown[0];
            if (dropdownNode && (dropdownNode === dropdown || dropdownNode.contains(target))) return select;
          }
          return null;
        }

        function armPhysicalChange(e) {
          var target = e.target;
          if (!target || !target.closest) return;
          var control = target.closest('input, select, textarea');
          var selectizeInput = selectizeInputForTarget(target);
          if (selectizeInput) control = selectizeInput;
          var selectizeHost = target.closest('.selectize-control');
          if (selectizeHost && selectizeHost.parentElement) {
            var originalSelect = selectizeHost.parentElement.querySelector('select');
            if (originalSelect) originalSelect.__wlPhysicalChangeArmed = true;
            if (!control) control = originalSelect;
          }
          if (!control) {
            var label = target.closest('label');
            var labelFor = label && label.getAttribute('for');
            if (labelFor) control = document.getElementById(labelFor);
          }
          if (!control) return;
          control.__wlPhysicalChangeArmed = true;
        }

        document.addEventListener('mousedown', armPhysicalChange, true);
        document.addEventListener('pointerdown', armPhysicalChange, true);
        document.addEventListener('keydown', armPhysicalChange, true);
        document.addEventListener('touchstart', armPhysicalChange, true);

        function recordServerExpected(event) {
          var message = event && event.message;
          if (!message || !message.id) return;

          var el = document.getElementById(message.id);
          if (!el) return;

          // `shiny:updateinput` can announce a choices-only update. It does
          // not authorize an empty selection; preserve the last canonical
          // value until Shiny announces an actual value.
          if (message.value === undefined) return;

          var expected = message.value;
          if (expected === null) {
            expected = el.type === 'checkbox' || el.type === 'radio'
              ? false
              : (el.multiple ? [] : '');
          }

          el.__wlServerExpected = expected;
          el.__wlPhysicalChangeArmed = false;
          el.__wlObjectUserChangeAuthorized = false;
          el.__prev_value = expected;
          if (el.type === 'checkbox' || el.type === 'radio') {
            el.__prev_checked = !!expected;
          }
        }

        // Shiny emits this as a jQuery custom event. Keep native registration
        // for direct dispatches, but also observe the real jQuery event so
        // server updates are not mistaken for browser restoration.
        document.addEventListener('shiny:updateinput', recordServerExpected);
        if (window.jQuery) {
          window.jQuery(document)
            .off('shiny:updateinput.wlAutofillContract')
            .on('shiny:updateinput.wlAutofillContract', recordServerExpected);
        }

        function currentValue(target) {
          if (target.type === 'checkbox' || target.type === 'radio') return target.checked;
          if (target.tagName === 'SELECT' && target.multiple) {
            return Array.prototype.map.call(target.selectedOptions || [], function(option) { return option.value; });
          }
          return target.value;
        }

        function sameValue(actual, expected) {
          if (Array.isArray(actual) || Array.isArray(expected)) {
            var actualList = Array.isArray(actual) ? actual : [actual];
            var expectedList = Array.isArray(expected) ? expected : [expected];
            return expectedList.map(String).sort().join('\u001f') === actualList.map(String).sort().join('\u001f');
          }
          return String(actual) === String(expected);
        }

        function restorePreviousValue(target) {
          if (target.__prev_value === undefined) return;
          if (target.type === 'checkbox' || target.type === 'radio') {
            target.checked = !!target.__prev_checked;
          } else if (target.tagName === 'SELECT' && target.multiple && Array.isArray(target.__prev_value)) {
            if (target.selectize) {
              target.selectize.setValue(target.__prev_value, true);
            } else {
              Array.prototype.forEach.call(target.options || [], function(option) {
                option.selected = target.__prev_value.indexOf(option.value) >= 0;
              });
            }
          } else {
            target.value = target.__prev_value;
            if (target.selectize) target.selectize.setValue(target.__prev_value, true);
          }
        }

        function resolveGuardedControl(target) {
          if (!target || !target.closest) return target;
          if (target.id) return target;
          var selectizeHost = target.closest('.selectize-control');
          if (selectizeHost && selectizeHost.parentElement) {
            return selectizeHost.parentElement.querySelector('select') || target;
          }
          return target;
        }

        function handleInputChange(event) {
          var target = resolveGuardedControl(event.target);
          if (!target || !target.id) return;
          var nativeEvent = event.originalEvent || event;
          if (nativeEvent.__wlAutofillContractHandled) return;
          nativeEvent.__wlAutofillContractHandled = true;

          var physical = target.__wlPhysicalChangeArmed === true || target.__wlObjectUserChangeAuthorized === true;
          var objectSelector = target.closest && target.closest('[data-wl-object-selector="true"]');
          target.__wlPhysicalChangeArmed = false;
          // Shared object-selector bridge runs later in the same change event.
          // Preserve physical provenance explicitly instead of consuming it at
          // this guard boundary.
          target.__wlObjectUserChangeAuthorized = !!(physical && objectSelector);
          var expectedValue = target.__wlServerExpected;
          var matchesExpected = expectedValue !== undefined && sameValue(currentValue(target), expectedValue);

          // Only physical input or the exact value announced by Shiny may
          // change canonical state. No elapsed-time heuristic is involved.
          if (!physical && !matchesExpected) {
            event.stopImmediatePropagation();
            event.preventDefault();
            console.warn('[AUTOFILL GUARD] blocked unauthorized change:', target.id, {
              value: currentValue(target),
              previous: target.__prev_value,
              expected: expectedValue
            });
            restorePreviousValue(target);
            return;
          }

          var actualValue = currentValue(target);
          target.__prev_value = actualValue;
          if (target.type === 'checkbox' || target.type === 'radio') target.__prev_checked = target.checked;
          if (physical || matchesExpected) {
            delete target.__wlServerExpected;
          }
        }

        function getCanonicalValue(el) {
          var container = typeof el.closest === 'function' ? el.closest('[data-canonical-value]') : null;
          var val = el.getAttribute('data-canonical-value') || (container ? container.getAttribute('data-canonical-value') : null);
          if (val !== undefined && val !== null) return val;
          
          if (el.tagName === 'SELECT' && el.multiple) {
            return Array.prototype.map.call(el.options || [], function(option) {
              return option.hasAttribute('selected') || option.defaultSelected ? option.value : null;
            }).filter(function(value) { return value !== null; });
          } else if (el.tagName === 'SELECT') {
            var selOpt = el.querySelector('option[selected]');
            if (selOpt) return selOpt.value;
            return el.options.length > 0 ? el.options[0].value : '';
          } else if (el.type === 'checkbox' || el.type === 'radio') {
            return el.hasAttribute('checked') || el.defaultChecked;
          } else {
            return el.getAttribute('value') || el.defaultValue || '';
          }
        }

        function initElement(el) {
          var id = el.id || '';
          // Browser restoration is only a state-sync risk for selectors and
          // boolean controls. Sliders/text fields have their own physical
          // input lifecycle; guarding every recluster_new_* input can block
          // legitimate drag/change events and make unrelated controls appear
          // empty after a valid user action.
          var isBoolean = el.tagName === 'INPUT' &&
            (el.type === 'checkbox' || el.type === 'radio');
          var isSelector = el.tagName === 'SELECT';
          var explicitlyGuarded = el.getAttribute('data-wl-autofill-guard') === 'true';
          // Analysis inline selector intentionally stages multiple choices and
          // commits once on dropdown close. Its synthetic commit is a valid
          // control lifecycle, not browser restoration; keep it outside this
          // single-value autofill contract.
          var isStagedAnalysisSelector = id === 'active_object_name_input_inline' ||
            id === 'active_object_name_input_umap_inline';
          var shouldGuard = !!(isBoolean || isSelector || explicitlyGuarded) && id &&
            !isStagedAnalysisSelector && (
              id.startsWith('recluster_new_') ||
              id === 'active_object_name_input' ||
              id.startsWith('recluster_dataset_') ||
              explicitlyGuarded
            );
          if (shouldGuard) {
            if (!el.__guard_registered) {
              el.__guard_registered = true;
              el.addEventListener('change', handleInputChange, true);
              if (window.jQuery) {
                window.jQuery(el).on('change', handleInputChange);
              }
            }

            if (el.__prev_value === undefined) {
              var canonicalVal = getCanonicalValue(el);
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_value = canonicalVal;
                el.__prev_checked = canonicalVal;
                if (el.checked !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled checkbox/radio on init:', el.id, 'from:', el.checked, 'to:', canonicalVal);
                  el.checked = canonicalVal;
                }
              } else {
                el.__prev_value = canonicalVal;
                if (el.value !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled select/input on init:', el.id, 'from:', el.value, 'to:', canonicalVal);
                  el.value = canonicalVal;
                  if (el.selectize) {
                    el.selectize.setValue(canonicalVal, true);
                  }
                }
              }
            }
          }
        }

        function initElements(root) {
          var scope = root && root.querySelectorAll ? root : document;
          var els = scope.querySelectorAll('input, select, textarea');
          if (scope.nodeType === 1 && /^(INPUT|SELECT|TEXTAREA)$/.test(scope.tagName)) {
            els = Array.prototype.slice.call(els);
            els.unshift(scope);
          }
          for (var i = 0; i < els.length; i++) {
            initElement(els[i]);
          }
        }

        initElements();
        document.addEventListener('shiny:connected', function() { initElements(); });
        document.addEventListener('shiny:value', function(ev) {
          initElements(ev && ev.target);
        }, true);
        document.addEventListener('shiny:bound', function(ev) {
          initElements(ev && ev.target);
        }, true);
        document.addEventListener('shiny:recalculated', function(ev) {
          initElements(ev && ev.target);
        }, true);

      })();
