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

*/ #NIVEL 2

State, Binding, Observation:
    Se utilizo state para los estados que pertenecian a la misma vista como isGrid para controlar el tipo de listado o grid que se mostraba la lista.
    Un binding se puede usar para pasar estados a un elemento hijo que necesite leer o actualizar datos del estado que se le pasa, en esta etapa decidí que era mejor ocupar un clousure para actualizar el estado del viewModel, asi no tenemos dependencias complejas y tenemos mejor separacion de responsabilidades.
    En cuanto a observation, con el nuevo @observable de swift, hicimos todo nuestro viewModel observable sin preocuparnos por @published ni @observedObject, lo cual permite a la vista reacccionar a los cambios de los valores de nuestro viewModel y actualizar la vista.
Flujo de datos: 
    El flujo de datos de favoritos comienza cuando se  construye PokemonDetail usando un estado observable como viewModel.isFavorite, y capturando ese mismo viewModel en un clousure junto con el metodo para actualizar el favorito, entonces cuando hace tap en la estrella de favorito en PokemonDetail, este actualiza la lista en el viewModel observado, lo cual hace que swift evalue las vistas que tienen dependencia (o estan usando algun estado observado) y las actualiza.
Auditoría de accesibilidad:
    En el proyecto se utilizaron fuentes con dynamic types como .title para que estas se adapten al tamaño dinamico, de igual forma se ocultaron elementos como el icono "person" por ser solo decorativo y se le dio un label real a los circulos de los tipos en el listado, se utilizo @scaledMetric en el tamaño de la imagen de boton de favoritos para que se adapte a los cambios de fuente y no quede muy pequeña cuando el nombre del pokemon se agrande. Se mejoro la descripcion en accessibility labes para que describan mejor el estado de los botones como "Show all" o "Show favorites only" asi como "mark/unmark favorite). 
Decisiones técnicas y limitaciones conocidas:
    Decidí que listState y isFavorite vivieran en el viewModel y en la capa de presentacion, y no de dominio, asi mantenemos nuestros modelos simples y sencillos y desacoplados.
    El buscador y botones de filtrado se muestran en todas las pantallas de resultados, para mejorar la experiencia de usuario e indicar que lo que cambia es unicamente el resultado de la busqueda (list o grid), seria redundante tenerla en todas y bloqueante no tenerlo en alguna.
    En simulateCallAPI se llama un metodo de sleep con un parametro personalizado para simular latencia en llamados a API y observar el loading state, a la vez que permitimos reducir el tiempo de espera en los tests.
    

*/
