(* Slawomir Gorawski *)

type 'a t = 'a cell Lazy.t
  and 'a cell = Nil | Cons of 'a * 'a t

let hd (s : 'a t) =
  match Lazy.force s with
  | Nil -> failwith "empty"
  | Cons (x, xs) -> x

let tl (s : 'a t) =
  match Lazy.force s with
  | Nil -> failwith "empty"
  | Cons (x, xs) -> xs

let rec (++) (s1 : 'a t) (s2 : 'a t) =
  match Lazy.force s1 with
  | Nil -> s2
  | Cons (x, xs) -> lazy (Cons (x, xs ++ s2))

let init f =
  let rec aux i =
    lazy (Cons (f i, aux (i + 1)))
  in aux 0

let rec map f (s : 'a t) =
  match Lazy.force s with
  | Nil -> lazy Nil
  | Cons (x, xs) -> lazy (Cons (f x, map f xs))

let rec map2 f (s1 : 'a t) (s2 : 'b t) =
  match Lazy.force s1, Lazy.force s2 with
  | Cons (x, xs), Cons (y, ys) -> lazy (Cons (f x y, map2 f xs ys))
  | _, _ -> lazy Nil

let rec combine (s1 : 'a t) (s2 : 'b t) =
  match Lazy.force s1, Lazy.force s2 with
  | Cons (x, xs), Cons (y, ys) -> lazy (Cons ((x, y), combine xs ys))
  | _, _ -> lazy Nil

let rec split (s : ('a * 'b) t) =
  (map fst s, map snd s)

let rec filter f (s : 'a t) =
  match Lazy.force s with
  | Nil -> lazy Nil
  | Cons (x, xs) ->
      if f x
      then lazy (Cons(x, filter f xs))
      else filter f xs

let rec find_opt f (s : 'a t) =
  match Lazy.force s with
  | Nil -> None
  | Cons (x, xs) ->
      if f x
      then Some x
      else find_opt f xs

let rec concat (sss : 'a t t) : 'a t =
  match Lazy.force sss with
  | Nil -> lazy Nil
  | Cons (s, ss) -> begin
    match Lazy.force s with
    | Nil -> concat ss
    | Cons (x, xs) -> lazy (Cons (x, xs ++ (concat ss)))
  end

let rec nth n (s : 'a t) =
  match n, Lazy.force s with
  | _, Nil -> failwith "Streams.nth"
  | 0, Cons (x, xs) -> x
  | n, Cons (x, xs) when n > 0 -> nth (n - 1) xs
  | _, _ -> invalid_arg "Streams.nth"

let rec take n (s : 'a t) =
  match n, Lazy.force s with
  | 0, _ -> lazy Nil
  | n, _ when n < 0 -> invalid_arg "Streams.take"
  | n, Nil -> failwith "Streams.take"
  | n, Cons (x, xs) -> lazy (Cons (x, take (n - 1) xs))

let rec drop n (s : 'a t) =
  match n, Lazy.force s with
  | 0, _ -> s
  | n, _ when n < 0 -> invalid_arg "Streams.drop"
  | n, Nil -> failwith "Streams.drop"
  | n, Cons (x, xs) -> drop (n - 1) xs

let rec list_of_stream (s : 'a t) =
  match Lazy.force s with
  | Nil -> []
  | Cons (x, xs) -> x :: list_of_stream xs

let rec stream_of_list xss =
  match xss with
  | [] -> lazy Nil
  | x :: xs -> lazy (Cons (x, stream_of_list xs))
