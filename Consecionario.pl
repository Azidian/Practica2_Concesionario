% vehicle(Make, Reference, Type, Price, Year).

vehicle(lamborghini, urus, suv, 218000 , 2018).  
vehicle(bmw, competition, suv, 122000, 2023).
vehicle(mercedesbenz, suv, sedan,  118000 , 2024).
vehicle(porsche, 911, sport, 230000, 2024).
vehicle(bugatti, chiron, sport, 5000000, 2024).
vehicle(cLaren, senna, sport, 1000000, 2020 ).
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
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.
