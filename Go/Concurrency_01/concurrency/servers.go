package concurrency

import (
	"time"
	"fmt"
	"math/rand"
	"os"
	"bufio"
	"strconv"
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
		if CompanyTalkative == true {
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
		if CompanyTalkative == true {
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
		if CompanyTalkative == true {
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

func TaxOfficer (taskServer chan *TaskToDo, productServer chan *Product) {
	if CompanyTalkative == false {
		reader := bufio.NewReader(os.Stdin)
		for {
			fmt.Println("Please put command:")
			fmt.Println("1 : Show number of tasks waiting in vector")
			fmt.Println("2 : Show number of tasks created in total")
			fmt.Println("3 : Show number of products waiting in vector")
			fmt.Println("4 : Show number of products created in total")
			commandString, _ := reader.ReadString((byte)('\n'))
			command, _ := strconv.Atoi(string([]byte(commandString)[0]))
			if command == 1 {
				fmt.Print("Number of tasks waiting in vector: ")
				fmt.Println(len(taskServer))
			}
			if command == 3 {
				fmt.Print("Number of products waiting in vector: ")
				fmt.Println(len(productServer))
			}
			fmt.Println(command)
		}
	}
}
