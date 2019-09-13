print_endline(MyDep.secret);

print_endline(MyDep2.secret); /* values that can potentially be null are type checked correctly! */

Random.self_init();

let msg =
  Random.int(2) === 0
    ? Js.null : Js.Null.return("This message might not display.");

/* values that can potentially be null are type checked correctly! */
Random.self_init();

let msg =
  Random.int(2) === 0
    ? Js.null : Js.Null.return("This message might not display.");

switch (Js.Null.to_opt(msg)) {
| None => ()
| Some(msg) => print_endline(msg)
}; /* let's try some BuckleScript-JavaScript interop */

Js.Global.setTimeout(() =>
  print_endline("Here's a message after a 1 second timeout."), 1000
);