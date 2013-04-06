App.Authorization.Permissions = {
  _perms:    {},
  register: function(name, klass) { this._perms[name] = klass; },
  get:      function(name, attrs) { return this._perms[name].create(attrs); },
  can:      function(name, attrs) { return this.get(name, attrs).get("can"); }
}