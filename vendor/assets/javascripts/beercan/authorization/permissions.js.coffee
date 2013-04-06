App.Authorization.Permissions =
  _perms:    {}
  register: (name, klass) -> 
    @_perms[name] = klass
  
  get: (name, attrs) -> 
    @_perms[name].create(attrs)
  
  can: (name, attrs) -> 
    @get(name, attrs).get("can")
