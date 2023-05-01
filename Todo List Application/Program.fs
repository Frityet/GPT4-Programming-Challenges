open System
open System.Collections.Generic

type TodoItem = {
    Id: int
    Title: string
    Completed: bool
}

let mutable todoItems = new Dictionary<int, TodoItem>()

let printTodoList () =
    Console.WriteLine("Current To-Do List:")
    for todo in todoItems do
        let status = if todo.Value.Completed then "[X]" else "[ ]"
        Console.WriteLine("{0} {1}: {2}", status, todo.Value.Id, todo.Value.Title)

let addTodoItem title =
    let id = todoItems.Count + 1
    let todoItem = { Id = id; Title = title; Completed = false }
    todoItems.Add(id, todoItem)

let markTodoItemCompleted id =
    match todoItems.TryGetValue(id) with
    | true, item ->
        todoItems.[id] <- { item with Completed = true }
    | false, _ -> Console.WriteLine("No item found with id {0}", id)

let deleteTodoItem id =
    if todoItems.Remove(id) then
        Console.WriteLine("Item with id {0} has been deleted.", id)
    else
        Console.WriteLine("No item found with id {0}", id)

let processInput(input: string) =
    let parts = input.Split(' ')
    match parts.[0].ToLowerInvariant() with
    | "add" -> addTodoItem (String.Join(" ", parts.[1..]))
    | "complete" -> markTodoItemCompleted (Int32.Parse(parts.[1]))
    | "delete" -> deleteTodoItem (Int32.Parse(parts.[1]))
    | "list" -> printTodoList()
    | "exit" -> Environment.Exit(0)
    | _ -> Console.WriteLine("Invalid command. Please use add, complete, delete, list, or exit.")

[<EntryPoint>]
let main (args: string[]) =
    Console.WriteLine("Welcome to the F# To-Do List App!")

    let processCommand (cmd: string) =
        match cmd with
        | "list" -> printTodoList()
        | "exit" -> Environment.Exit(0)
        | _ -> Console.WriteLine("Invalid command. Please use add, complete, delete, list, or exit.")

    if args.Length = 0 then
        while true do
            Console.Write("> ")
            let input = Console.ReadLine()
            processInput input
    else
        for arg in args do
            processCommand arg
    0
