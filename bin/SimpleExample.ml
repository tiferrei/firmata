
(* - SimpleExample -
 * This example shows the basic use of the firmata board.
*)

open Firmata

let serial_port = "/dev/cu.usbmodemDC5475D154B82" ;;
let baud_rate = 115200;;

let rec waitTillReady board =
   update board 1;
   if not (isReady board) then waitTillReady board
;;

let main () =
   match openPort serial_port baud_rate with
   | OpenOk(board)   ->
      waitTillReady    board ;              (* waits for the board to be ready *)
      printInformation board;               (* prints the information of the board *)
      setSamplingRate  board 10 ;           (* sets the sampling rate to 10 ms *)
      setPinMode       board 13 OutputPin ; (* configures pin 13 as digital output *)
      (* infinite loop *)
      let rec loop _ =
         update board 1;                    (* updates the board and waits maximum 1 ms *)
         digitalWrite board 13 1;           (* Turns on pin 13 *)
         Unix.sleep 1;                      (* Waits 1s *)
         digitalWrite board 13 0;           (* Turns off pin 13 *)
         Unix.sleep 1;                      (* Waits 1s *)
         loop ()
      in loop ()
   | OpenError(msg) -> print_endline msg

;;

main () ;;
