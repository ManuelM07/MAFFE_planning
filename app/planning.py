from minizinc import Instance, Model, Solver
from datetime import timedelta

# Load planning model from file
planning_model = Model("./planning.mzn")
# Find the MiniZinc solver configuration for chuffed
chuffed = Solver.lookup("chuffed")
# Create an Instance of the planning model for chuffed
instance = Instance(chuffed, planning_model)

class Data:

    def __init__(self, n, min_, max_, d) -> None:
        self.n = n
        self.min = min_
        self.max = max_
        self.d = d
        self.result = None

    def get_solution(self):
        instance["n"] = self.n
        instance["Min"] = self.min
        instance["Max"] = self.max
        instance["D"] = self.d

        self.result = instance.solve(timeout=timedelta(seconds=5))

        return self.result