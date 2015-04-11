package body company is

   task body Chairman is

      tempTask : TaskPointer;
      counter : Integer := 1;
      G : Generator;
   begin
      Reset(G, 1);
      loop
         tempTask := new TaskToDo'(ParamA   => counter,
                                   ParamB   => counter + 2,
                                   Operator => (counter mod 3));
         taskServer.AddTask(tempTask);

         if CompanyTalkative then
            Put("Created task number ");
            Put(Integer'Image(counter));
            Put(". :");
            Put(Integer'Image(tempTask.ParamA));
            Put(" ");
            if tempTask.Operator = 0 then
               Put("+");
            end if;
            if tempTask.Operator = 1 then
               Put("-");
            end if;
            if tempTask.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempTask.ParamB));
            Put_Line("");
         end if;
         counter := counter + 1;

         delay 0.1+Duration(3.0*Random(G));
      end loop;
   end Chairman;

   task body Worker is

      tempTask : TaskPointer;
      tempProduct : ProductPointer;
   begin
      delay WorkersGoingToWorkTime;
      loop
         taskServer.PopTask(tempTask);
         tempProduct := CreateProduct(resolvedTask => tempTask);
         if CompanyTalkative then
            Put("Worker number ");
            Put(Integer'Image(number));
            Put(" solved task: ");
            Put(Integer'Image(tempTask.ParamA));
            Put(" ");
            if tempTask.Operator = 0 then
               Put("+");
            end if;
            if tempTask.Operator = 1 then
               Put("-");
            end if;
            if tempTask.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempTask.ParamB));
            Put_Line("");
         end if;

         ProductServer.AddProduct(tempProduct);
         delay WorkersBreak;
      end loop;
   end Worker;

   task body Customer is

      tempProduct : ProductPointer;
   begin
      delay CustomerGoingToStoreTime;
      loop
         productServer.PopProduct(tempProduct);

         if CompanyTalkative then
            Put("Product bought: ");
            Put(Integer'Image(tempProduct.ResolvedTask.ParamA));
            Put(" ");
            if tempProduct.ResolvedTask.Operator = 0 then
               Put("+");
            end if;
            if tempProduct.ResolvedTask.Operator = 1 then
               Put("-");
            end if;
            if tempProduct.ResolvedTask.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempProduct.ResolvedTask.ParamB));
            Put(" = ");
            Put(Integer'Image(tempProduct.Solution));
            Put_Line("");
         end if;

         delay WorkersBreak;
      end loop;
   end Customer;

   task body TaxOffice is
      RawCommand : String(1 ..1);
      Command : Integer := 0;
      taskReport : TaskReportPointer;
      productReport : ProductReportPointer;
      Last : Integer;
   begin
      if CompanyTalkative = False then
         loop
            Put_Line("Please put command:");
            Put_Line("1 : Show number of tasks waiting in vector");
            Put_Line("2 : Show number of tasks created in total");
            Put_Line("3 : Show number of products waiting in vector");
            Put_Line("4 : Show number of products created in total");

            Get_Line(RawCommand, Last);
            taskServer.TasksStatus(taskReport);
            productServer.ProductsStatus(productReport);
            Command := Integer'Value(RawCommand);
            if Command = 1 then
               Put("Number of tasks waiting in vector: ");
               Put_Line(Integer'Image(taskReport.VectorCount));
               if taskReport.VectorCount > 0 then
                  for i in 1 .. taskReport.VectorCount loop
                     Put(Integer'Image(taskReport.TasksVector.Element(Index => i).ParamA));
                     if taskReport.TasksVector.Element(Index => i).Operator = 0 then
                        Put(" + ");
                     end if;
                     if taskReport.TasksVector.Element(Index => i).Operator = 1 then
                        Put(" - ");
                     end if;
                     if taskReport.TasksVector.Element(Index => i).Operator = 2 then
                        Put(" * ");
                     end if;
                     Put_Line(Integer'Image(taskReport.TasksVector.Element(Index => i).ParamB));
                  end loop;
               end if;
            end if;
            if Command = 2 then
               Put("Number of tasks created in total: ");
               Put_Line(Integer'Image(taskReport.CreatedTasksCount));
            end if;
            if Command = 3 then
               Put("Number of products waiting in vector: ");
               Put_Line(Integer'Image(productReport.VectorCount));
               if productReport.VectorCount > 0 then
                  for i in 1 .. productReport.VectorCount loop
                     Put(Integer'Image(productReport.ProductsVector.Element(Index => i).ResolvedTask.ParamA));
                     if productReport.ProductsVector.Element(Index => i).ResolvedTask.Operator = 0 then
                        Put(" + ");
                     end if;
                     if productReport.ProductsVector.Element(Index => i).ResolvedTask.Operator = 1 then
                        Put(" - ");
                     end if;
                     if productReport.ProductsVector.Element(Index => i).ResolvedTask.Operator = 2 then
                        Put(" * ");
                     end if;
                     Put(Integer'Image(productReport.ProductsVector.Element(Index => i).ResolvedTask.ParamB));
                     Put(" = ");
                     Put_Line(Integer'Image(productReport.ProductsVector.Element(Index => i).Solution));
                  end loop;
               end if;
            end if;
            if Command = 4 then
               Put("Number of products created in total: ");
               Put_Line(Integer'Image(productReport.CreatedProductsCount));
            end if;
            Command := 0;
            --delay TaxOfficerWorkTime;
         end loop;
      end if;
   end TaxOffice;
end company;
