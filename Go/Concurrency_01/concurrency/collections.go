package concurrency

import (
)

type TaskToDo struct {
	ParamA int				// paramA: value of first parameter
	ParamB int				// paramB: value of second parameter
	Operator int			// operator: sign of operation that need to be done on parameters (0: +, 1: -, 2: *)
}

type Product struct {
	ResolvedTask *TaskToDo
	Solution int
}

func CreateTask (parameterA int, parameterB int, operator int) *TaskToDo {
	tempTask := new(TaskToDo)
	tempTask.ParamA = parameterA
	tempTask.ParamB = parameterB
	tempTask.Operator = operator
	return tempTask
}

func CreateProduct (resolvedTask *TaskToDo) *Product {
	tempProduct := new(Product)
	sol := 0
	if resolvedTask.Operator == 0 {
		sol = resolvedTask.ParamA + resolvedTask.ParamB
	}
	if resolvedTask.Operator == 1 {
		sol = resolvedTask.ParamA - resolvedTask.ParamB
	}
	if resolvedTask.Operator == 2 {
		sol = resolvedTask.ParamA * resolvedTask.ParamB
	}
	tempProduct.ResolvedTask = resolvedTask
	tempProduct.Solution = sol
	return tempProduct
}


