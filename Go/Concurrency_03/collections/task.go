package collections

import (
	"config"
)

type TaskToDo struct {
	ParamA int
	ParamB int
	Operator int
	Solution int
	Damaged bool
}

func CreateTask (paramA int, paramB int, op int) *TaskToDo {
	tempTask := new(TaskToDo)
	tempTask.ParamA = paramA
	tempTask.ParamB = paramB
	tempTask.Operator = op
	tempTask.Solution = -666
	tempTask.Damaged = false
	return tempTask
}

func TaskServer () chan *TaskToDo {
	tasks := make(chan *TaskToDo, config.MaximalTaskVectorSize)
	return tasks
}

func ProductServer () chan *TaskToDo {
	products := make(chan *TaskToDo, config.MaximalProductVectorSize)
	return products
}

