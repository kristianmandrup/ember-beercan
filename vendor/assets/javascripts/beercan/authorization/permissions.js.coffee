App.Authorization.Permissions =
  _perms:    {}
  register: (name, type) -> 
    @_perms[name] = type
  
  get: (name, attrs) -> 
    @_perms[name].create(attrs)
  
  can: (name, attrs) -> 
    @get(name, attrs).get("can")
