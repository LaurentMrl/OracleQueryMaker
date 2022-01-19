class roleMaker():

    def __init__(self, roleName, roleRights):
        self.roleName = roleName
        self.roleRights = roleRights
        self.makeRightsStr()
        self.makeRole()
    
    def makeRightsStr(self):
        self.rightsStr = f""
        for table in self.roleRights:
            self.rightsStr += f"GRANT "
            if table == "ANY TABLE":
                for right in self.roleRights[table]:
                    self.rightsStr += f"{right} {table}, "
            else:
                for right in self.roleRights[table]:
                    self.rightsStr += f"{right}, "
                self.rightsStr += f"ON {table} "
            self.rightsStr += f"TO {self.roleName};\n"

    def makeRole(self):
        roleStr = f"\n\nCREATE ROLE {self.roleName};\n{self.rightsStr}\n\n"
        print(roleStr)


rightsList = {"ANY TABLE" : ["SELECT", "ALTER", "DROP", "CREATE", "DELETE"], "PRODUIT" : ["SELECT", "ALTER"]}

role1 = roleMaker("commerce_A", rightsList)