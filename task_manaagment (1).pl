/* Define predicate task as dynamic so we can add and remove tasks during execution */
:- dynamic task/4.

/* 1. Create a task with unique ID, description, and assignee. Initialize completion status as false. */
create_task(ID, Descp, Usr) :-
    \+ task(ID, _, _, _),                 % Ensure ID is unique
    assertz(task(ID, Descp, Usr, false)),
    write('Task created: '), write(ID), nl.

/* 2. Assign a task to a new user */
assign_task(ID, NewU) :-
    task(ID, Descp, Usr, Stat),           % Find the task
    retract(task(ID, Descp, Usr, Stat)),  % Remove it
    assertz(task(ID, Descp, NewU, Stat)), % Insert it again with the new user
    write('Task '), write(ID), write(' assigned to '), write(NewU), nl.

/* 3. Mark a task as completed */
mark_completed(ID) :-
    task(ID, Descp, Usr, false),         % Ensure task exists and is incomplete
    retract(task(ID, Descp, Usr, false)), % Remove incomplete task
    assertz(task(ID, Descp, Usr, true)),  % Add it back as completed
    write('Task '), write(ID), write(' marked as completed.'), nl.

/* 4. Display all tasks */
display_tasks :-
    write('All Tasks:'), nl,
    forall(task(ID, Descp, Usr, Stat),
           (write('Task: '), write(ID), nl,
            write('- Description: '), write(Descp), nl,
            write('- Assignee: '), write(Usr), nl,
            write('- Completion status: '), write(Stat), nl, nl)).

/* 5. Display all completed tasks */
display_all_completed_tasks :-
    write('All Completed Tasks:'), nl,
    forall(task(ID, Descp, Usr, true),                  % For each completed task, print details
           (write('Task: '), write(ID), nl,
            write('- Description: '), write(Descp), nl,
            write('- Assignee: '), write(Usr), nl, nl)).

/* 6. Display all incomplete tasks */
display_all_incomplete_tasks :-
    write('Incomplete Tasks:'), nl,
    forall(task(ID, Descp, Usr, false),                % For each incomplete task, print details
           (write('Task: '), write(ID), nl,
            write('- Description: '), write(Descp), nl,
            write('- Assignee: '), write(Usr), nl, nl)).

/* 7. Display tasks assigned to a specific user */
display_tasks_assigned_to(Usr) :-
    write('Tasks assigned to '), write(Usr), write(':'), nl,
    (   forall(task(ID, Descp, Usr, Stat),
               (write('Task: '), write(ID), nl,
                write('- Description: '), write(Descp), nl,
                write('- Completion status: '), write(Stat), nl, nl))
    ;   \+ task(_, _, Usr, _), % Check if no tasks are assigned to the user
        write('No tasks assigned to '), write(Usr), nl
    ).

/* Example usage:
?- create_task(1, 'Implement login functionality', 'Alice').
?- create_task(2, 'Design homepage layout', 'Bob').
?- assign_task(1, 'John').
?- assign_task(2, 'Alice').
?- mark_completed(2).
?- display_tasks.
?- display_tasks_assigned_to('Alice').
?- display_all_completed_tasks.
?- display_all_incomplete_tasks.
*/