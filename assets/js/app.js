// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Hooks for interactive components
let Hooks = {}

Hooks.HtmlEncoder = {
  mounted() {
    const input = this.el.querySelector('[data-encoder-input]')
    const output = this.el.querySelector('[data-encoder-output]')
    const copyBtn = this.el.querySelector('[data-encoder-copy]')

    const htmlEncode = (str) => {
      return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;')
    }

    input.addEventListener('input', () => {
      const encoded = htmlEncode(input.value)
      if (encoded) {
        output.textContent = encoded
      } else {
        output.innerHTML = '<span class="text-muted-foreground">Encoded text will appear here...</span>'
      }
    })

    copyBtn.addEventListener('click', () => {
      const text = output.textContent
      if (text && navigator.clipboard) {
        navigator.clipboard.writeText(text)
      }
    })
  }
}

Hooks.TextEncoder = {
  mounted() {
    const input = this.el.querySelector('[data-encoder-input]')
    const output = this.el.querySelector('[data-encoder-output]')
    const copyBtn = this.el.querySelector('[data-encoder-copy]')
    const switchBtn = document.getElementById('encoder-mode-switch')
    
    let currentMode = 'html'

    const htmlEncode = (str) => {
      return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;')
    }

    const urlEncode = (str) => {
      return encodeURIComponent(str)
    }

    const encode = (str) => {
      if (!str) return ''
      return currentMode === 'html' ? htmlEncode(str) : urlEncode(str)
    }

    const updateOutput = () => {
      const encoded = encode(input.value)
      if (encoded) {
        output.textContent = encoded
      } else {
        output.innerHTML = '<span class="text-muted-foreground">Encoded text will appear here...</span>'
      }
    }

    // Watch for switch state changes
    if (switchBtn) {
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.attributeName === 'data-state') {
            currentMode = switchBtn.dataset.state === 'checked' ? 'url' : 'html'
            updateOutput()
          }
        })
      })
      observer.observe(switchBtn, { attributes: true })
    }

    input.addEventListener('input', updateOutput)

    copyBtn.addEventListener('click', () => {
      const text = output.textContent
      if (text && navigator.clipboard) {
        navigator.clipboard.writeText(text)
      }
    })
  }
}

Hooks.JsonFormatter = {
  mounted() {
    const input = this.el.querySelector('[data-json-input]')
    const output = this.el.querySelector('[data-json-output]')
    const copyBtn = this.el.querySelector('[data-json-copy]')
    const formatBtn = this.el.querySelector('[data-json-format]')
    const clearBtn = this.el.querySelector('[data-json-clear]')
    const errorEl = this.el.querySelector('[data-json-error]')
    const successEl = this.el.querySelector('[data-json-success]')

    // Syntax highlighting for JSON
    const highlightJson = (json) => {
      return json
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*")(\s*:)?/g, (match, p1, p2, p3) => {
          let cls = 'text-green-600 dark:text-green-400' // string
          if (p3) {
            cls = 'text-blue-600 dark:text-blue-400' // key
          }
          return `<span class="${cls}">${match}</span>`
        })
        .replace(/\b(true|false)\b/g, '<span class="text-purple-600 dark:text-purple-400">$1</span>')
        .replace(/\b(null)\b/g, '<span class="text-gray-500 dark:text-gray-400">$1</span>')
        .replace(/\b(-?\d+\.?\d*)\b/g, '<span class="text-orange-600 dark:text-orange-400">$1</span>')
    }

    const formatJson = () => {
      const value = input.value.trim()
      
      // Reset states
      errorEl.classList.add('hidden')
      successEl.classList.add('hidden')
      
      if (!value) {
        output.innerHTML = '<span class="text-muted-foreground">Formatted JSON will appear here...</span>'
        return
      }

      try {
        const parsed = JSON.parse(value)
        const formatted = JSON.stringify(parsed, null, 2)
        output.innerHTML = highlightJson(formatted)
        successEl.classList.remove('hidden')
      } catch (e) {
        output.innerHTML = '<span class="text-muted-foreground">Invalid JSON - check error below</span>'
        errorEl.textContent = `✗ ${e.message}`
        errorEl.classList.remove('hidden')
      }
    }

    // Format on button click
    formatBtn.addEventListener('click', formatJson)

    // Format on input (with debounce)
    let timeout
    input.addEventListener('input', () => {
      clearTimeout(timeout)
      timeout = setTimeout(formatJson, 300)
    })

    // Clear button
    clearBtn.addEventListener('click', () => {
      input.value = ''
      output.innerHTML = '<span class="text-muted-foreground">Formatted JSON will appear here...</span>'
      errorEl.classList.add('hidden')
      successEl.classList.add('hidden')
    })

    // Copy formatted output
    copyBtn.addEventListener('click', () => {
      const text = output.textContent
      if (text && !text.includes('Formatted JSON will') && !text.includes('Invalid JSON') && navigator.clipboard) {
        navigator.clipboard.writeText(text)
      }
    })
  }
}

Hooks.PasswordGenerator = {
  mounted() {
    const output = this.el.querySelector('[data-password-output]')
    const copyBtn = this.el.querySelector('[data-password-copy]')
    const lengthSlider = this.el.querySelector('[data-password-length]')
    const lengthDisplay = this.el.querySelector('[data-password-length-display]')
    const regenerateBtn = this.el.querySelector('[data-password-regenerate]')
    const optionCheckboxes = this.el.querySelectorAll('[data-password-option]')

    const charsets = {
      uppercase: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      lowercase: 'abcdefghijklmnopqrstuvwxyz',
      numbers: '0123456789',
      symbols: '!@#$%^&*()_+-=[]{}|;:,.<>?'
    }

    const getOptions = () => {
      const options = {}
      optionCheckboxes.forEach(cb => {
        const input = cb.querySelector('input[type="checkbox"]') || cb
        options[cb.dataset.passwordOption] = input.checked
      })
      return options
    }

    const generatePassword = () => {
      const length = parseInt(lengthSlider.value) || 16
      const options = getOptions()
      
      let charset = ''
      if (options.uppercase) charset += charsets.uppercase
      if (options.lowercase) charset += charsets.lowercase
      if (options.numbers) charset += charsets.numbers
      if (options.symbols) charset += charsets.symbols

      if (!charset) {
        output.innerHTML = '<span class="text-muted-foreground">Select at least one character type</span>'
        return
      }

      // Use crypto.getRandomValues for secure random generation
      const array = new Uint32Array(length)
      crypto.getRandomValues(array)
      
      let password = ''
      for (let i = 0; i < length; i++) {
        password += charset[array[i] % charset.length]
      }

      output.textContent = password
    }

    // Update length display when slider changes
    lengthSlider.addEventListener('input', () => {
      lengthDisplay.textContent = lengthSlider.value
    })

    // Generate on regenerate button click
    if (regenerateBtn) {
      regenerateBtn.addEventListener('click', generatePassword)
    }

    // Copy password to clipboard
    copyBtn.addEventListener('click', () => {
      const text = output.textContent
      if (text && !text.includes('Click generate') && !text.includes('Select at least') && navigator.clipboard) {
        navigator.clipboard.writeText(text)
      }
    })

    // Regenerate when options change
    optionCheckboxes.forEach(cb => {
      const input = cb.querySelector('input[type="checkbox"]') || cb
      input.addEventListener('change', () => {
        // Only regenerate if we already have a password
        if (output.textContent && !output.textContent.includes('Click generate')) {
          generatePassword()
        }
      })
    })

    // Generate initial password
    generatePassword()
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


// Allows to execute JS commands from the server
window.addEventListener("phx:js-exec", ({detail}) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})

// Copy to clipboard handler
window.addEventListener("phx:copy", (event) => {
  const text = event.detail.text
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text)
  }
})
