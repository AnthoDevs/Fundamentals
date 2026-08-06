/* #Nivel 1

Struct vs class:
 Move y type son entidades simples e inmutables que solo representan datos, entonces nos interesa su value type.
 Pokemon tambien nos conviene copiarlo de forma independiente evitando que sea modificado en otras partes por accidente.
 Trainer es una entidad con identidad que cambia durante la ejecucion, y nos interesa su reference type para poder acceder a ella desde distintas partes.
 Gym tambien nos interesa compartir su referencia con otras entidades como Trainers.
 

Valor vs referencia: un ejemplo concreto de tu propio código donde eso importó (por ejemplo, ¿qué pasaría si Team fuera una clase?).
Si team fuera una clase se mantendria la referencia a esa instancia, lo cual hace mas probable un retain cycle y mas dificil de liberar si se manda como parametro a una funcion en lugar de mandar una copia de sus valores.

ARC: explica tu ciclo de Trainer/Gym, por qué ocurre, y por qué weak en Gym.trainer lo resuelve (no unowned — ¿por qué no?).

se utiliza weak por que trainer puede ser liberado antes que el gym, es decir gym puede o no tener referencia a trainer y trainer de la misma forma puede o no tener referencia a gym por lo tanto no dependen del ciclo de vida del otro sin poder garantizar cual deja de existir primero.

Decisiones técnicas y limitaciones conocidas: ya tomaste varias decisiones interesantes en el camino que vale la pena documentar — el orden de validación en Team.add (full antes que duplicado), tu elección de maxMultiplier (máximo) en vez de multiplicar tipos duales, cambiar attack/defense/power a Double. Anótalas con el "por qué", no solo el "qué".

 */
/* Validaciones en Team:
Primero se evalua si el team esta lleno, ya que para que un pokemon sea evaluado si ya existe al ingresar deberá tener espacio para ingresar, de no ser asi no puede ejecutarse la validacion si ya existe ese id en el team.
 
 Se toma en cuenta solo la maxima debilidad del la tabla de effectividad para mantener este proyecto simple y centrarse en lo importante
 
Se asignarion los ataques, defensa, power como Double para facilitar los calculos, dejando el formateo en la parte de presentacion cuando se incorpore.

*/
