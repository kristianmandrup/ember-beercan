Ember.Handlebars.registerBoundHelper 'can', (object, options) ->

    permission = EmberDeviseExample.Authorization.create
        action: options.hash.action
        object: object

    permission.authorize()

    options.contexts = [permission]

    Ember.Handlebars.helpers.boundIf.call(permission, "can", options)

    {{#can score action=destroy}}