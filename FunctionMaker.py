class functionMaker():

    def __init__(self, functionName, functionArgs, functionReturn, functionAlgo):
        self.functionName = functionName
        self.functionArgs = functionArgs
        self.functionReturn = functionReturn
        self.functionAlgo = functionAlgo
        self.makeArgs()
        self.makeArgsStr()
        self.makeFunctionStr()

    def makeArgs(self):
        self.argsList = []
        for arg in self.functionArgs:
            arg = functionArg(arg, self.functionArgs[arg])
            self.argsList.append(arg)

    def makeArgsStr(self):
        self.argsStr = f""
        for arg in self.argsList:
            self.argsStr += f"{arg.argName} IN {arg.argType} "

    def makeFunctionStr(self):
        funcStr = f"\n\nCREATE OR REPLACE FUNCTION {self.functionName} ({self.argsStr})\nRETURN {self.functionReturn} IS\nBEGIN\n   RETURN {self.functionAlgo};\nEND\n\n"
        print(funcStr)

class functionArg():

    def __init__(self, argName, argType):
        self.argName = argName
        self.argType = argType
        # print(f"Hey je suis là mon nom d'argument est {self.argName}, et je suis un {self.argType}")
argsListBefore = {'num1' : "NUMBER", 'num2' : "NUMBER"}

myFunction = functionMaker("pourcentage_val", argsListBefore, "NUMBER", "((num2*100)/num1)")