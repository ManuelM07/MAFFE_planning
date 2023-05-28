from minizinc import Instance, Model, Solver
from datetime import timedelta

# Load planning model from file
planning_model = Model("./app/planning.mzn")
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

        if self.n <= 4 :
            aux_time = 0
        else:
            aux_time = 10

        self.result = instance.solve(timeout=timedelta(seconds=60*aux_time))

        return self.result