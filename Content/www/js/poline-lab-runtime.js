import { Poline, positionFunctions, randomHSLPair, randomHSLTriple } from './poline-picker.vendored.js'

const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, Number(v)))

function hslToHex(h, s, l) {
  const hh = ((Number(h) % 360) + 360) % 360
  const ss = clamp(s, 0, 1)
  const ll = clamp(l, 0, 1)

  const c = (1 - Math.abs(2 * ll - 1)) * ss
  const x = c * (1 - Math.abs((hh / 60) % 2 - 1))
  const m = ll - c / 2

  let r = 0, g = 0, b = 0
  if (hh < 60) [r, g, b] = [c, x, 0]
  else if (hh < 120) [r, g, b] = [x, c, 0]
  else if (hh < 180) [r, g, b] = [0, c, x]
  else if (hh < 240) [r, g, b] = [0, x, c]
  else if (hh < 300) [r, g, b] = [x, 0, c]
  else [r, g, b] = [c, 0, x]

  const toHex = (n) => Math.round((n + m) * 255).toString(16).padStart(2, '0').toUpperCase()
  return `#${toHex(r)}${toHex(g)}${toHex(b)}`
}

function makeAnchors(n) {
  if (n <= 2) return randomHSLPair()
  if (n === 3) return randomHSLTriple()

  const start = Math.random() * 360
  const out = []
  for (let i = 0; i < n; i++) {
    const h = (start + (360 / n) * i + (Math.random() * 24 - 12) + 360) % 360
    const s = 0.55 + Math.random() * 0.4
    const l = 0.35 + Math.random() * 0.45
    out.push([h, s, l])
  }
  return out
}

function getPositionFunction(name) {
  const map = {
    sinusoidal: positionFunctions.sinusoidalPosition,
    linear: positionFunctions.linearPosition,
    quadratic: positionFunctions.quadraticPosition,
    exponential: positionFunctions.exponentialPosition,
    arc: positionFunctions.arcPosition
  }
  return map[name] || positionFunctions.sinusoidalPosition
}

function buildPayload(poline, meta = {}) {
  const colors = poline.colors || []
  const colorsHex = colors.map(([h, s, l]) => hslToHex(h, s, l))
  const anchors = (poline.anchorPoints || []).map((p) => p.hsl)

  return {
    colors_hex: colorsHex,
    colors_hsl: colors,
    anchors_hsl: anchors,
    num_points: poline.numPoints,
    closed_loop: poline.closedLoop,
    meta: {
      source: meta.source || 'interactive',
      timestamp_ms: Date.now(),
      ...meta
    }
  }
}

function initPolineLab() {
  const picker = document.getElementById('poline_picker_wc')
  if (!picker) return
  if (picker.dataset.polineMounted === '1') return
  const fallback = document.getElementById('poline_picker_fallback')

  const showFallback = (msg) => {
    if (!fallback) return
    fallback.style.display = 'flex'
    if (msg) fallback.textContent = msg
  }

  const hideFallback = () => {
    if (!fallback) return
    fallback.style.display = 'none'
  }

  if (window.customElements && !window.customElements.get('poline-picker')) {
    showFallback('Loading Poline picker runtime...')
    window.customElements.whenDefined('poline-picker').then(() => {
      setTimeout(initPolineLab, 0)
    })
    return
  }

  if (typeof picker.setPoline !== 'function') {
    showFallback('Poline picker failed to initialize. Retrying...')
    setTimeout(initPolineLab, 80)
    return
  }

  picker.dataset.polineMounted = '1'
  hideFallback()

  const anchorN = document.getElementById('poline_anchor_n')
  const points = document.getElementById('poline_points')
  const fn = document.getElementById('poline_position_fn')
  const closed = document.getElementById('poline_closed_loop')
  const hueShift = document.getElementById('poline_hue_shift')
  const randomizeBtn = document.getElementById('poline_randomize')
  const applyBtn = document.getElementById('poline_apply')

  let poline = null

  const pushToShiny = (payload) => {
    if (window.Shiny) {
      window.Shiny.setInputValue('poline_runtime_payload', payload, { priority: 'event' })
    }
  }

  const buildPoline = ({ keepAnchors = false, source = 'apply' } = {}) => {
    const n = Math.max(2, Math.min(6, parseInt(anchorN?.value || '3', 10)))
    const p = Math.max(2, Math.min(20, parseInt(points?.value || '6', 10)))
    const posFn = getPositionFunction(fn?.value || 'sinusoidal')
    const closedLoop = !!closed?.checked
    const shift = Number(hueShift?.value || 0)

    let anchors = keepAnchors && poline ? poline.anchorPoints.map((a) => a.hsl) : makeAnchors(n)
    if (anchors.length !== n) anchors = makeAnchors(n)
    if (shift !== 0) anchors = anchors.map(([h, s, l]) => [h + shift, s, l])

    poline = new Poline({
      anchorColors: anchors,
      numPoints: p,
      closedLoop,
      positionFunction: posFn
    })

    picker.setPoline(poline)
    pushToShiny(buildPayload(poline, { source, position_function: fn?.value || 'sinusoidal', hue_shift: shift }))
  }

  picker.setAttribute('interactive', '')
  picker.setAttribute('allow-add-points', '')

  picker.addEventListener('poline-change', (ev) => {
    if (ev?.detail?.poline) {
      poline = ev.detail.poline
      pushToShiny(buildPayload(poline, { source: 'picker_drag', position_function: fn?.value || 'sinusoidal', hue_shift: Number(hueShift?.value || 0) }))
    }
  })

  randomizeBtn?.addEventListener('click', () => {
    buildPoline({ keepAnchors: false, source: 'randomize' })
  })

  applyBtn?.addEventListener('click', () => {
    buildPoline({ keepAnchors: true, source: 'apply' })
  })

  anchorN?.addEventListener('change', () => buildPoline({ keepAnchors: false, source: 'anchor_count' }))

  buildPoline({ keepAnchors: false, source: 'init' })
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initPolineLab)
} else {
  initPolineLab()
}

document.addEventListener('shiny:connected', () => {
  setTimeout(initPolineLab, 0)
})
