class Persona{
  var emociones = []
  var edad

  method esAdolescente() = edad > 12 && edad < 19

  method sentirNuevaEmocion(emocion) = emociones.add(emocion)

  method estaPorExplotar() = emociones.all({emocion => emocion.puedeLiberarse()}) 

  method vivirUnEvento(impactoEvento, descripcionEvento) = emociones.forEach({emocion => emocion.vivirUnEvento(self.crearEvento(impactoEvento, descripcionEvento))})

  method crearEvento(impactoEvento, descripcionEvento) = new Evento(impacto = impactoEvento, descripcion = descripcionEvento)

  method cambiarValorIntensidadElevada(nuevoValor) = emociones.forEach({emocion => emocion.cambiarIntensidadElevada(nuevoValor)})
  
}

class Evento{
  const impacto
  const descripcion

  method impacto() = impacto

  method descripcion() = descripcion
}

class Emociones{
  var intensidadActual
  var intensidadElevada = 50
  var eventosVividos

  method intensidadActual() = intensidadActual

  method puedeLiberarse() = self.intensidadActualMayorA(intensidadElevada)

  method liberarse(evento)

  method vivirUnEvento(evento){
    eventosVividos += 1
    self.liberarse(evento)
    }

  method cambiarIntensidadElevada(intensidadNueva){intensidadElevada = intensidadNueva}

  method intensidadActualMayorA(cantidad) = intensidadActual > cantidad

}

class Furia inherits Emociones{
  const palabrotas = []

  method cambiarIntensidad(intensidadNueva){intensidadActual = intensidadNueva}

  method aprenderPalabrota(palabrota){palabrotas.add(palabrota)}
  method olvidarPalabrota(palabrota){palabrotas.remove(palabrota)}

  override method puedeLiberarse() = super() && palabrotas.any({palabra => palabra.size() > 7})

  override method liberarse(evento){
    if(self.puedeLiberarse()){
    intensidadActual -= evento.impacto()
    self.olvidarPalabrota(palabrotas.first())
    }
  }
}

class Alegria inherits Emociones{
  override method puedeLiberarse() = super() && ((eventosVividos % 2) == 0) 

  override method liberarse(evento){
    if(self.puedeLiberarse()){
      const intensidadADisminuir = intensidadActual - evento.impacto()
      if(intensidadADisminuir < 0)
        intensidadActual = intensidadADisminuir.abs()
      else
        intensidadActual = intensidadADisminuir
    }
  }
}

class Tristeza inherits Emociones{
  var causa = "melancolia"

  method cambiarIntensidad(intensidadNueva){intensidadActual = intensidadNueva}

  override method puedeLiberarse() = (causa != "melancolia") && super()

  method cambiarCausa(causaNueva){causa = causaNueva}

  override method liberarse(evento){
    if(self.puedeLiberarse()){
      self.cambiarCausa(evento.descripcion())
      intensidadActual -= evento.impacto()
    }
  }
}

class Desagrado inherits Emociones{

  override method puedeLiberarse() = super() && eventosVividos > intensidadActual

  override method liberarse(evento){
    if(self.puedeLiberarse()){
      intensidadActual -= evento.impacto()
    }
  }
}

class Temor inherits Desagrado{}

class Ansiedad inherits Emociones{
  var horasPensandoFuturo

  override method puedeLiberarse() = horasPensandoFuturo > 12

  override method liberarse(evento){
    if(self.puedeLiberarse()){
      horasPensandoFuturo = 0
    }else{
      horasPensandoFuturo += 1
    }
  }
}

/*
Use POLIMORFISMO en puedeLiberarse y liberarse, este concepto es muy importante ya que a la hora de enviar mensajes a las emociones
mediante las personas no tenemos que mandar mensaje a cada una de las emociones sino que con simplemente poner emociones.liberarse() o 
puedeLiberarse() ya TODAS las emociones entienden este mensaje

Use herencia con EMOCIONES ya que Ansiedad comparte muchos mensajes y atributos con las demas emociones entonces para no repetir codigo
y hacer un codigo mejor decido abstraer el comportamiento y atributos comunes a una calse EMOCIONES para que despues cada emocion la herede
*/
