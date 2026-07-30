(function() {
        if (/Mac|iPhone|iPad|iPod/.test(navigator.platform || '')) {
          document.documentElement.classList.add('Pinhki-platform-mac');
        }
      })();

(function() {
        var lastInteractionTime = 0;
        var inputsUpdatingFromServer = {};

        function recordInteraction(e) {
          lastInteractionTime = Date.now();
        }

        document.addEventListener('mousedown', recordInteraction, true);
        document.addEventListener('keydown', recordInteraction, true);
        document.addEventListener('touchstart', recordInteraction, true);

        document.addEventListener('shiny:updateinput', function(event) {
          if (event.message && event.message.id) {
            var id = event.message.id;
            inputsUpdatingFromServer[id] = event.message.value;
            var el = document.getElementById(id);
            if (el) {
              el.__prev_value = event.message.value;
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_checked = event.message.value;
              }
              console.log('[AUTOFILL DIAGNOSTIC] Server update message for:', id, 'value:', event.message.value);
            }
            setTimeout(function() {
              delete inputsUpdatingFromServer[id];
            }, 0);
          }
        });

        function handleInputChange(event) {
          var target = event.target;

          // Always allow programmatic changes from selectize/Shiny scripts (untrusted/synthetic events)
          var isSynthetic = event.isTrusted === false || 
                            event.isTrusted === undefined || 
                            (event.originalEvent && event.originalEvent.isTrusted === false) ||
                            (event.originalEvent && event.originalEvent.isTrusted === undefined);
          if (isSynthetic) {
            target.__prev_value = target.value;
            if (target.type === 'checkbox' || target.type === 'radio') {
              target.__prev_checked = target.checked;
            }
            return;
          }

          if (target.value === target.__prev_value) {
            if (target.type === 'checkbox' || target.type === 'radio') {
              if (target.checked === target.__prev_checked) return;
            } else {
              return;
            }
          }

          var timeSinceInteraction = Date.now() - lastInteractionTime;
          var isUpdating = inputsUpdatingFromServer.hasOwnProperty(target.id);
          var expectedValue = inputsUpdatingFromServer[target.id];
          var matchesExpected = false;
          if (isUpdating) {
            if (target.type === 'checkbox' || target.type === 'radio') {
              matchesExpected = String(target.checked) === String(expectedValue);
            } else {
              matchesExpected = String(target.value) === String(expectedValue);
            }
          }

          console.log('[AUTOFILL DIAGNOSTIC] Change event on guarded input:', target.id, 
            'value:', target.value, 
            'checked:', target.checked,
            'prev:', target.__prev_value, 
            'isUpdating:', isUpdating, 
            'expectedValue:', expectedValue, 
            'matchesExpected:', matchesExpected, 
            'timeSinceInteraction:', timeSinceInteraction
          );

          if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
            event.stopImmediatePropagation();
            event.preventDefault();
            if (target.__prev_value !== undefined) {
              target.value = target.__prev_value;
              if (target.type === 'checkbox' || target.type === 'radio') {
                target.checked = target.__prev_checked;
              }
              if (target.selectize) {
                target.selectize.setValue(target.__prev_value, false);
              }
            }
            console.log('[AUTOFILL GUARD] Blocked browser auto-restore/autofill on:', target.id, 
              'value was:', target.value, 
              'reset to:', target.__prev_value
            );
          } else {
            target.__prev_value = target.value;
            if (target.type === 'checkbox' || target.type === 'radio') {
              target.__prev_checked = target.checked;
            }
          }
        }

        function getCanonicalValue(el) {
          var container = typeof el.closest === 'function' ? el.closest('[data-canonical-value]') : null;
          var val = el.getAttribute('data-canonical-value') || (container ? container.getAttribute('data-canonical-value') : null);
          if (val !== undefined && val !== null) return val;
          
          if (el.tagName === 'SELECT') {
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
          var shouldGuard = id && (
            id.startsWith('recluster_new_') || 
            id.startsWith('active_object_name_') || 
            id.startsWith('recluster_dataset_')
          ) && !id.includes('_color_') && el.type !== 'color';
          if (shouldGuard) {
            if (!el.__guard_registered) {
              el.__guard_registered = true;
              el.addEventListener('change', handleInputChange, true);
              if (window.jQuery) {
                window.jQuery(el).on('change', handleInputChange);
              } else {
                var checkJQuery = setInterval(function() {
                  if (window.jQuery) {
                    clearInterval(checkJQuery);
                    window.jQuery(el).on('change', handleInputChange);
                  }
                }, 50);
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

        function initElements() {
          var els = document.querySelectorAll('input, select, textarea');
          for (var i = 0; i < els.length; i++) {
            initElement(els[i]);
          }
        }

        initElements();
        document.addEventListener('shiny:connected', initElements);
        document.addEventListener('shiny:value', initElements);
        document.addEventListener('shiny:bound', initElements);
        document.addEventListener('shiny:recalculated', initElements);

        // MutationObserver to catch dynamically added nodes immediately upon insertion
        var observer = new MutationObserver(function(mutations) {
          for (var i = 0; i < mutations.length; i++) {
            var addedNodes = mutations[i].addedNodes;
            for (var j = 0; j < addedNodes.length; j++) {
              var node = addedNodes[j];
              if (node.nodeType === 1) {
                var els = node.querySelectorAll ? node.querySelectorAll('input, select, textarea') : [];
                if (node.tagName === 'INPUT' || node.tagName === 'SELECT' || node.tagName === 'TEXTAREA') {
                  els = Array.prototype.slice.call(els);
                  els.unshift(node);
                }
                for (var m = 0; m < els.length; m++) {
                  initElement(els[m]);
                }
              }
            }
          }
        });
        observer.observe(document.documentElement, {
          childList: true,
          subtree: true
        });

        // Active background poller running every 50ms to detect and reverse browser form-restoration value changes
        setInterval(function() {
          var guardedIds = [
            'active_object_name_input_inline', 
            'active_object_name_input_umap_inline', 
            'recluster_dataset_select'
          ];
          for (var k = 0; k < guardedIds.length; k++) {
            var el = document.getElementById(guardedIds[k]);
            if (!el) continue;
            
            if (el.__prev_value === undefined) {
              var canonicalVal = getCanonicalValue(el);
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_value = canonicalVal;
                el.__prev_checked = canonicalVal;
                if (el.checked !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled checkbox on query:', el.id, 'from:', el.checked, 'to:', canonicalVal);
                  el.checked = canonicalVal;
                }
              } else {
                el.__prev_value = canonicalVal;
                if (el.value !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled select/input on query:', el.id, 'from:', el.value, 'to:', canonicalVal);
                  el.value = canonicalVal;
                  if (el.selectize) {
                    el.selectize.setValue(canonicalVal, true);
                  }
                }
              }
            } else {
              if (el.type === 'checkbox' || el.type === 'radio') {
                if (el.checked !== el.__prev_checked) {
                  var timeSinceInteraction = Date.now() - lastInteractionTime;
                  var isUpdating = inputsUpdatingFromServer.hasOwnProperty(el.id);
                  var expectedValue = inputsUpdatingFromServer[el.id];
                  var matchesExpected = isUpdating && String(el.checked) === String(expectedValue);

                  console.log('[AUTOFILL DIAGNOSTIC] Poller detected checkbox change on:', el.id, 
                    'checked:', el.checked, 
                    'prev:', el.__prev_checked, 
                    'isUpdating:', isUpdating, 
                    'expectedValue:', expectedValue,
                    'matchesExpected:', matchesExpected,
                    'timeSinceInteraction:', timeSinceInteraction
                  );

                  if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
                    console.log('[AUTOFILL GUARD] Reset unauthorized checkbox/radio change:', el.id, 'from:', el.checked, 'to:', el.__prev_checked);
                    el.checked = el.__prev_checked;
                  } else {
                    el.__prev_checked = el.checked;
                    el.__prev_value = el.checked;
                  }
                }
              } else {
                if (el.value !== el.__prev_value) {
                  var timeSinceInteraction = Date.now() - lastInteractionTime;
                  var isUpdating = inputsUpdatingFromServer.hasOwnProperty(el.id);
                  var expectedValue = inputsUpdatingFromServer[el.id];
                  var matchesExpected = isUpdating && String(el.value) === String(expectedValue);

                  console.log('[AUTOFILL DIAGNOSTIC] Poller detected select change on:', el.id, 
                    'value:', el.value, 
                    'prev:', el.__prev_value, 
                    'isUpdating:', isUpdating, 
                    'expectedValue:', expectedValue,
                    'matchesExpected:', matchesExpected,
                    'timeSinceInteraction:', timeSinceInteraction
                  );

                  if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
                    console.log('[AUTOFILL GUARD] Reset unauthorized input change:', el.id, 'from:', el.value, 'to:', el.__prev_value);
                    el.value = el.__prev_value;
                    if (el.selectize) {
                      el.selectize.setValue(el.__prev_value, false);
                    }
                  } else {
                    el.__prev_value = el.value;
                  }
                }
              }
            }
          }
        }, 50);
      })();
