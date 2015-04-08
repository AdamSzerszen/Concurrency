package concurrency

import (
	"time"
	"fmt"
	"math/rand"
)

func TaskServer () chan *TaskToDo {
	tasks := make(chan *TaskToDo, MaximalTaskVectorSize)
	return tasks
}

func ProductServer () chan *Product {
	products := make(chan *Product, MaximalProductVectorSize)
	return products
}

func Chairman (taskServer chan *TaskToDo) {
	rand.Seed( time.Now().UTC().UnixNano())
	var interval time.Duration
	counter := 1
	for {
		tempTask := CreateTask(counter, counter + 2, counter % 3)
		taskServer <- tempTask
		if CompanyTalkative {
			fmt.Print("Created task number ")
			fmt.Print(counter)
			fmt.Print(". : ")
			fmt.Print(tempTask.ParamA)
			fmt.Print(" ")
			if tempTask.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempTask.Operator == 1 {
				fmt.Print("- ")
			}
			if tempTask.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempTask.ParamB)
			fmt.Println()
		}
		counter++
		interval = time.Duration(rand.Intn(15))
		time.Sleep(time.Second * interval)
	}
}

func Worker (taskServer chan *TaskToDo, productServer chan *Product, number int) {
	time.Sleep(time.Second * time.Duration(WorkersGoingToWorkTime))
	for {
		tempProduct := CreateProduct(<-taskServer)
		if CompanyTalkative {
			fmt.Print("Worker number: ")
			fmt.Print(number)
			fmt.Print(" solved task: ")
			fmt.Print(tempProduct.ResolvedTask.ParamA)
			fmt.Print(" ")
			if tempProduct.ResolvedTask.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempProduct.ResolvedTask.Operator == 1 {
				fmt.Print("- ")
			}
			if tempProduct.ResolvedTask.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempProduct.ResolvedTask.ParamB)
			fmt.Println()
		}
		productServer <- tempProduct
		time.Sleep(time.Second * time.Duration(WorkersBreak))
	}
}

func Customer (productServer chan *Product) {
	time.Sleep(time.Second * time.Duration(CustomerGoingToStoreTime))
	for {
		tempProduct := <- productServer
		if CompanyTalkative {
			fmt.Print("Product bought: ")
			fmt.Print(tempProduct.ResolvedTask.ParamA)
			fmt.Print(" ")
			if tempProduct.ResolvedTask.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempProduct.ResolvedTask.Operator == 1 {
				fmt.Print("- ")
			}
			if tempProduct.ResolvedTask.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempProduct.ResolvedTask.ParamB)
			fmt.Print(" = ")
			fmt.Print(tempProduct.Solution)
			fmt.Println()
		}
		time.Sleep(time.Second * time.Duration(CustomerBreak))
	}
}
