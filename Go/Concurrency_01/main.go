package main

import (
	"concurrency"
	"time"
	"fmt"
)

func main() {
	exitChanel := make(chan int)
	tasks := concurrency.TaskServer()
	products := concurrency.ProductServer()
	go concurrency.TaxOfficer(tasks, products)
	go concurrency.Chairman(tasks)
	go concurrency.Customer(products)
	for i := 1; i <= concurrency.NumberOfWorkers; i++{
		if concurrency.CompanyTalkative == true {
			fmt.Print("Worker number ");
			fmt.Print(i)
			fmt.Println(" started his day!")
		}
		go concurrency.Worker(tasks, products, i)
		time.Sleep(time.Second * time.Duration(concurrency.WorkerEmploymentTime))
	}
	<-exitChanel
}
