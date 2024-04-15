/*
 !En esta clase vamos a trbajar la escritura del fichero que irá al FTP

 * En esta clase vamos a escribir los ficheros, pero no vamos a mandarlos
 * al FTP, sino que vamos a devolver esos ficheros para que el repositorio
 * del FTP los mande.

 * Además esta clase tampoco va a hacer peticiones directamente a la base
 *de datos, sino que va a recibir los datos ya procesados para escribirlos.

 !IMPORTANTE: Esta clase debe ser sencilla y es un prototipo, es decir, si
 !se necesita más funcionalidad se debe crear una clase nueva.
*/

import '../../../data/!data.dart';

class DataFileWriter{

  Map<dynamic, String> files = {
    Driver(): 'conductores.txt',
    VehicleRegistration(): 'matriculas.txt',
    Rancher(): 'ganaderos.txt',
    Slaughterhouse(): 'mataderos.txt',
    Client(): 'clientes.txt',
    Product(): 'productos.txt',
    Classification(): 'clasifiaciones.txt',
    Performance(): 'rendimientos.txt'
  };

  //TODO: Crear un método que escriba los ficheros que vamos a enviar.
  /*
  ! Este método debe leer de la base de datos los datos que vamos a enviar
  ! al ftp y escribirlos en un fichero.

  * Este fichero que vamos a escribir NO lo vamos a enviar directamente al ftp
  * sino que lo vamos a devolver para que el repositorio del ftp lo envíe.
  */
}