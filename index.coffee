racer = require('k-model')
Model = racer.Model
isServer = racer.util.isServer

class Toast

	view: __dirname
	name: 'k-toast'

	defaultOptions =
		sticky: false
		timeout: 10000

	Model::toast = (type, msg, options) ->

		# support also function signature toast({ error: 'error message' }, options})
		if typeof type is 'object'
			options = msg
			for own key, val of type
				t = key
				msg = val
			type = t

		sticky = options?.sticky || defaultOptions.sticky
		timeout = options?.timeout || defaultOptions.timeout
		toast =
			id: @id()
			type: type
			msg: msg

		toast.click = options.click if options?.click

		if isServer
			@root.set '_page.isServer', true
			@root.set '_page.timeout', timeout

		remove = =>
			toasts = @root.get('_page.toast')
			if toasts
				for t, i in toasts
					if t.id is toast.id
						t.click() if t.click
						@root.remove('_page.toast', i)
						return

		# add toast
		@root.unshift '_page.toast', toast, (err) -> setTimeout(remove, timeout) if !sticky

	# click handler
	remove: (i) ->
		@model.root.remove '_page.toast', i


module.exports = Toast
