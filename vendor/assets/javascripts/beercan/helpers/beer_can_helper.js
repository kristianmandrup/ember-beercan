var get = Ember.get, isGlobalPath = Ember.isGlobalPath, normalizePath = Ember.Handlebars.normalizePath;

var getProp = function(context, property, options) {
  if (isGlobalPath(property)) {
    return get(property);
  } else {
    var path = normalizePath(context, property, options.data);
    return get(path.root, path.path);
  }
};

Handlebars.registerHelper('can', function(permissionName, property, options){
  var attrs, context, key, path, permission;

  // property is optional, if we've only got 2 arguments then the property contains our options
  if (!options) {
    options = property;
    property = null;
  }

  context = (options.contexts && options.contexts[0]) || this;

  attrs = {};

  // if we've got a property name, get its value and set it to the permission's content
  // this will set the passed in `post` to the content eg:
  // {{#can editPost post}} ... {{/can}}
  if (property) {
    attrs.content = getProp(context, property, options);
  }

  // if we've got any options, find their values eg:
  // {{#can createPost project:Project user:App.currentUser}} ... {{/can}}
  for (key in options.hash) {
    path = options.hash[key];
    attrs[key] = getProp(context, path, options);
  }

  // find & create the permission with the supplied attributes
  permission = App.Authorization.Permissions.get(permissionName, attrs);

  // ensure boundIf uses permission as context and not the view/controller
  // otherwise it looks for 'can' in the wrong place
  options.contexts = null;

  // bind it all together and kickoff the observers
  return Ember.Handlebars.helpers.boundIf.call(permission, "can", options);
});