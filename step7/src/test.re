print_endline MyDep.secret;

print_endline MyDep2.secret;

/* let's try some BuckleScript-JavaScript interop */
/* values that can potentially be null are type checked correctly! */
let msg =
  ReasonJs.Math.random () > 0.5 ? Js.null : Js.Null.return "This message might not display.";

switch (Js.Null.to_opt msg) {
| None => ()
| Some msg => print_endline msg
};

ReasonJs.setTimeout (fun () => print_endline "This is running on Node.js!") 1000;
