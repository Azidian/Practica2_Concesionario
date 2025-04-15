% vehicle(Make, Reference, Type, Price, Year).

vehicle(lamborghini, urus, suv, 218000 , 2018).   
vehicle(bmw, competition, suv, 122000, 2023).
vehicle(mercedesbenz, glc, sedan, 118000, 2024).
vehicle(porsche, 911, sport, 230000, 2024).
vehicle(bugatti, chiron, sport, 5000000, 2024).
vehicle(mclaren, senna, sport, 1000000, 2020 ).
vehicle(chevrolet, blazer, suv, 38000, 2024).
vehicle(mazda, cx-90, suv, 40000, 2024).
vehicle(toyota, corolla, sedan, 25000, 2023).
vehicle(toyota, rav4, suv, 28000, 2022).
vehicle(ford, mustang, sport, 45000, 2023).
vehicle(ford, explorer, suv, 35000, 2021).
vehicle(bmw, x5, suv, 60000, 2021).
vehicle(bmw, series3, sedan, 40000, 2022).
vehicle(honda, civic, sedan, 22000, 2023).
vehicle(honda, crv, suv, 27000, 2022).
vehicle(chevrolet, silverado, pickup, 45000, 2021).
vehicle(nissan, frontier, pickup, 32000, 2022).

% Filtro por tipo y presupuesto
meet_budget(Reference, BudgetMax) :- 
    vehicle(_, Reference, _, Price, _), % Obtener el precio del vehículo
    Price =< BudgetMax. % Verificar si el precio es menor o igual al presupuesto máximo

% Filtrar vehículos por precio 
filter_by_price(Vehicles, Limit, FilteredVehicles) :- 
    sort_by_price(Vehicles, SortedVehicles), % Ordenar vehículos por precio
    select_until_limit(SortedVehicles, Limit, 0, FilteredVehicles). % Seleccionar vehículos hasta el límite

% Función auxiliar para seleccionar vehículos hasta el límite   
select_until_limit([], _, _, []). % Caso base: lista vacía
select_until_limit([vehicle(Make, Ref, Type, Price, Year) | Tail], Limit, Accumulated, [vehicle(Make, Ref, Type, Price, Year) | FilteredTail]) :-
    NewAccumulated is Accumulated + Price, % Sumar el precio del vehículo actual
    NewAccumulated =< Limit, % Verificar si no se excede el límite
    select_until_limit(Tail, Limit, NewAccumulated, FilteredTail). % Continuar seleccionando vehículos
select_until_limit(_, Limit, Accumulated, []) :-
    Accumulated > Limit. 

% Ordenar vehículos por precio 
sort_by_price(Vehicles, SortedVehicles) :- %Vehículos y vehículos ordenados
    predsort(compare_by_price, Vehicles, SortedVehicles). % Ordenar vehículos por precio

compare_by_price(Order, vehicle(_, _, _, Price1, _), vehicle(_, _, _, Price2, _)) :- % Comparar precios de vehículos
    % Order es el predicado que define la relación de orden entre los precios
    (Price1 < Price2 -> Order = (<) ; Order = (>)). % Definir la relación de orden

% Lista de vehículos por marca
list_by_make(Make, References) :- % Marca y referencias
    findall(Ref, vehicle(Make, Ref, _, _, _), References). % Obtener referencias de vehículos por marca

% Generación de informe
generate_report(Brand, Type, Budget, FinalList) :- % Marca, tipo y presupuesto
    % Filtramos por marca, tipo y presupuesto individual
    findall(vehicle(Brand, Ref, Type, Price, Year), % Obtener vehículos por marca y tipo
            (vehicle(Brand, Ref, Type, Price, Year), Price =< Budget), % Filtrar por presupuesto
            RawList),
    total_value(RawList, Total), 
    (
        Total =< 1000000 ->
            FinalList = RawList
        ;
            filter_by_price(RawList, 1000000, FinalList) % Filtramos por presupuesto total si excede 1,000,000
    ).

% Sumar precios de una lista de vehículos
total_value([], 0). % Caso base: lista vacía
total_value([vehicle(_, _, _, Price, _) | Tail], Total) :- 
    total_value(Tail, SubTotal),
    Total is Price + SubTotal. % Sumar precios de vehículos

% Casos de prueba
% 1. Listar todos los SUV Toyota por debajo de $30,000
test_toyota_suv(Result) :-
    findall(Ref, (vehicle(toyota, Ref, suv, Price, _), Price < 30000), Result).

% 2. Vehículos Ford agrupados por tipo y año
test_ford_by_type_year(Result) :-
    bagof((Type, Year, Ref), vehicle(ford, Ref, Type, _, Year), Result).

% 3. Valor total de Sedanes sin exceder $500,000
test_sedan_value(Vehicles, TotalValue) :-
    findall(vehicle(Make, Ref, sedan, Price, Year), 
            vehicle(Make, Ref, sedan, Price, Year), 
            AllSedans),
    filter_by_price(AllSedans, 500000, Vehicles),
    total_value(Vehicles, TotalValue).

% 4. Mostrar todos los vehículos que cumplen con un presupuesto individual
vehicles_within_budget(Budget, Vehicles) :-
    findall(vehicle(Make, Ref, Type, Price, Year),
            (vehicle(Make, Ref, Type, Price, Year), Price =< Budget),
            Vehicles).

% 5. Generar reporte para BMW tipo SUV con presupuesto de 130000
test_generate_report_bmw(Result) :-
    generate_report(bmw, suv, 130000, Result).

% 6. Listar referencias por marca
test_list_by_make(Result) :-
    list_by_make(honda, Result).
