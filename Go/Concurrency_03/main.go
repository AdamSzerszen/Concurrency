package main

import (
	"companies"
	"config"
	"shops"
	"factories"
	"clients"
)

func main() {
	exitChanel := make(chan int)
	var allFactories [config.NumberOfFactories]*factories.Factory
	var logistics [config.NumberOfLogisticCompanies]*companies.LogisticCompany
	var allShops [config.NumberOfShops]*shops.Shop

	for i := 0; i < config.NumberOfLogisticCompanies; i++{
		logistics[i] = companies.CreateLogisticCompany()
		go logistics[i].Start()
	}
	for i := 0; i < config.NumberOfFactories; i++ {
		allFactories[i] = factories.CreateFactory(logistics[i])
		go allFactories[i].Start()
	}
	for i := 0; i < config.NumberOfShops; i++ {
		if i % 2 == 0 {
			allShops[i] = shops.CreateShop(i, i, logistics[0])
		} else {
			allShops[i] = shops.CreateShop(i, i, logistics[1])
		}
		go allShops[i].Start()
	}
	for i := 0; i < config.NumberOfClients; i++ {
		go clients.Client(allShops)
	}
	<- exitChanel
}


