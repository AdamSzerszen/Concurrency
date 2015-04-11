package body collections is

   function CreateTask (parameterA : in Integer;
                        parameterB : in Integer;
                        operator : in Integer) return TaskPointer is

      tempTask : TaskPointer;

   begin
      tempTask := new TaskToDo'(ParamA   => parameterA,
                                ParamB   => parameterB,
                                Operator => operator);
      return tempTask;
   end CreateTask;


   function CreateProduct (resolvedTask : in TaskPointer)
                           return ProductPointer is
      tempProduct : ProductPointer;
      solution : Integer;
   begin

      if resolvedTask.Operator = 0 then
         solution := resolvedTask.ParamA + resolvedTask.ParamB;
      end if;
      if resolvedTask.Operator = 1 then
         solution := resolvedTask.ParamA - resolvedTask.ParamB;
      end if;
      if resolvedTask.Operator = 2 then
         solution := resolvedTask.ParamA * resolvedTask.ParamB;
      end if;

      tempProduct := new Product'(ResolvedTask => resolvedTask,
                                  Solution     => solution);
      return tempProduct;
   end CreateProduct;

   function CreateTaskReport (createdTaskCount : in Integer;
                              vectorCount : in Integer;
                              tasksVector : in TaskVector.Vector)
                              return TaskReportPointer is
      tempReport : TaskReportPointer;
      totalCount : Integer;
   begin
      totalCount := createdTaskCount;
      tempReport := new TaskReport'(CreatedTasksCount => createdTaskCount,
                                    VectorCount       => vectorCount,
                                    TasksVector       => tasksVector);
      return tempReport;
   end CreateTaskReport;

   function CreateProductReport (createdProductCount : in Integer;
                                 vectorCount : in Integer;
                                 productsVector : in ProductVector.Vector)
                                 return ProductReportPointer is
      tempReport : ProductReportPointer;
      totalCount : Integer;
   begin
      totalCount := createdProductCount;
      tempReport := new ProductReport'(CreatedProductsCount => createdProductCount,
                                       VectorCount          => vectorCount,
                                       ProductsVector        => productsVector);
      return tempReport;
   end CreateProductReport;

end collections;
