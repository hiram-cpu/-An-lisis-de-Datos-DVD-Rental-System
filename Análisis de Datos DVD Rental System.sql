/*---------------------------------------------------------------------------------
  --------------------------- DQL - Data Query Languaje ---------------------------*/

 Use dvdrental 
 go

 /*---------------------------------------------------------------------------------
  --------------------------- Nombres y filtros ---------------------------*/
  -- Nos permitira la gestion basica de inventario 

--1. Vamos a seleccionar el nombre y apellido de los actores

SELECT 
    first_name, 
    last_name
FROM 
    actor;

--2. Vamos a seleccionar el nombre completo del actor en una sola columna

SELECT 
    CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM 
    actor;
	
--3. Selecciona los actores que su nombre empieza con "D"

SELECT 
    first_name, 
    last_name	
FROM 
    actor
WHERE 
    first_name LIKE 'D%';	

/*---------------------------------------------------------------------------------
  --------------------------- Duplicidad de Nombres ---------------------------*/
  --Identifica posibles riesgos en la integridad de datos o registros de personas que comparten nombres comunes.

--4. ¿Tenemos algún actor con el mismo nombre?

SELECT 
    first_name, 
    COUNT(*) AS cantidad_repeticiones
FROM 
    actor
GROUP BY 
    first_name
HAVING 
    COUNT(*) > 1;	

/*---------------------------------------------------------------------------------
  --------------------------- Precios de Renta ---------------------------*/
  -- Permite identificar la estrategia de precios. Las películas con costo máximo definen el "segmento premium" del catálogo.

--5. ¿Cuál es el costo máximo de renta de una película?

SELECT 
    MAX(rental_rate) AS costo_maximo
FROM 
    film;

--6. ¿Cuáles son las peliculas que fueron rentadas con ese costo?	
	
SELECT 
    title AS titulo_pelicula, 
    rental_rate AS costo_renta
FROM 
    film
WHERE 
    rental_rate = (SELECT MAX(rental_rate) FROM film);

/*---------------------------------------------------------------------------------
  --------------------------- Precios de Renta ---------------------------*/
-- Muestra el enfoque de mercado. Si la mayoría son 'PG' o 'PG-13', el negocio está dirigido a un público familiar.

--7. ¿Cuantás películas hay por el tipo de audencia (rating)?
	
SELECT 
    rating AS clasificacion, 
    COUNT(*) AS cantidad_peliculas
FROM 
    film
GROUP BY 
    rating;

/*---------------------------------------------------------------------------------
  --------------------------- Filtrado por Clasificación ---------------------------*/	 
-- Útil para generar catálogos filtrados para audiencias específicas.

--8. Selecciona las películas que no tienen un rating R o NC-17

SELECT 
    title AS titulo_pelicula, 
    rating AS clasificacion
FROM 
    film
WHERE 
    rating NOT IN ('R', 'NC-17');	

/*---------------------------------------------------------------------------------
  --------------------------- Clientes por Tienda ---------------------------*/	 
-- Ayuda a balancear la carga operativa entre las sucursales físicas disponibles.
	
--9. ¿Cuantos clientes hay en cada tienda?
	
SELECT 
    store_id AS tienda_id, 
    COUNT(customer_id) AS cantidad_clientes
FROM 
    customer
GROUP BY 
    store_id;

/*---------------------------------------------------------------------------------
  --------------------------- Película más rentada ---------------------------*/	 
  -- Identifica el "Best Seller". Es clave para tomar decisiones de compra de inventario futuro (comprar más copias).

--10. ¿Cuál es la pelicula que mas veces se rento?

SELECT TOP 1 
    f.title AS pelicula, 
    COUNT(r.rental_id) AS veces_rentada
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    f.title
ORDER BY 
    veces_rentada DESC;

/*---------------------------------------------------------------------------------
  --------------------------- Inventario/Clientes Inactivos ---------------------------*/	 
  -- Las películas no rentadas representan "costo de oportunidad". Los clientes que nunca han rentado requieren campañas de marketing de reactivación.

--11. ¿Qué peliculas no se han rentado?

SELECT 
    f.title AS pelicula_no_rentada
FROM 
    film f
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.rental_id IS NULL;	
	
--12. ¿Qué clientes no han rentado ninguna película?

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
WHERE 
    r.rental_id IS NULL;
	
/*---------------------------------------------------------------------------------
  --------------------------- Productividad de Actores ---------------------------*/	 
  -- Define quiénes son las "estrellas" del catálogo. Es útil para recomendar películas basadas en actores populares.

--13. ¿Qué actores han actuado en más de 30 películas?

SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor, 
    COUNT(fa.film_id) AS total_peliculas
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, 
    a.first_name, 
    a.last_name
HAVING 
    COUNT(fa.film_id) > 30
ORDER BY 
    total_peliculas DESC;	

/*---------------------------------------------------------------------------------
  --------------------------- Ventas por Tienda ---------------------------*/	 
  -- Permite medir el rendimiento financiero real de cada sucursal más allá de la cantidad de clientes.

--14. Muestra las ventas totales por tienda

SELECT 
    s.store_id AS tienda_id, 
    SUM(CAST(p.amount AS DECIMAL(10,2))) AS ventas_totales
FROM 
    payment p
JOIN 
    staff s ON p.staff_id = s.staff_id
GROUP BY 
    s.store_id;

/*---------------------------------------------------------------------------------
  --------------------------- Lealtad de Clientes ---------------------------*/	 
  -- Identifica clientes recurrentes de películas específicas, útil para programas de lealtad personalizados.

--15. Muestra los clientes que rentaron una pelicula más de una vez
with a as (
    SELECT 
        r.customer_id, 
        i.film_id, 
        COUNT(*) AS veces_rentada
    FROM 
        rental r
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    GROUP BY 
        r.customer_id, 
        i.film_id
    HAVING 
        COUNT(*) > 1
)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    f.title AS pelicula,
    a.veces_rentada
FROM 
    a
JOIN 
    customer c ON a.customer_id = c.customer_id
JOIN 
    film f ON a.film_id = f.film_id
ORDER BY 
    a.veces_rentada DESC;

	
	