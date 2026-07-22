class MathQuestion {
  final int level;
  final String competency;
  final String topic;
  final String question;
  final List<String> options;
  final int correctIndex;

  const MathQuestion({
    required this.level,
    required this.competency,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class MathQuestionsRepository {
  static List<MathQuestion> level1 = [
    MathQuestion(
      level: 1,
      competency: 'Comprende el uso de fracciones para describir situaciones.',
      topic: 'Reciclaje',
      question:
          'Los niños de grado tercero elaboran ecoladrillos. ¿Qué fracción representa la figura mostrada en la tarjeta?',
      options: ['1/2', '1/3', '1/4', '3/4'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Interpreta y representa datos.',
      topic: 'Clasificación de residuos',
      question: '¿Quién ganó la competencia y cuántos puntos obtuvo?',
      options: [
        'Juan - 8 puntos',
        'Paula - 10 puntos',
        'Sara - 12 puntos',
        'Pedro - 6 puntos',
      ],
      correctIndex: 1,
    ),

    MathQuestion(
      level: 1,
      competency: 'División',
      topic: 'Reciclaje',
      question: '56 ecoladrillos deben repartirse entre 14 estudiantes.',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
    ),

    MathQuestion(
      level: 1,
      competency: 'Sumas y restas',
      topic: 'Clasificación',
      question: '¿Cuántos residuos quedaron en cada contenedor?',
      options: [
        'Verde 6 • Negro 4 • Blanco 5',
        'Verde 5 • Negro 4 • Blanco 6',
        'Verde 6 • Negro 5 • Blanco 4',
        'Verde 7 • Negro 3 • Blanco 5',
      ],
      correctIndex: 0,
    ),

    MathQuestion(
      level: 1,
      competency: 'Suma',
      topic: 'Reciclaje',
      question:
          'La familia de Juan recibe 1 kg de periódicos, 3 kg de revistas y 5 kg de propagandas.',
      options: ['7 kg', '8 kg', '9 kg', '10 kg'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Operaciones',
      topic: 'Reciclaje',
      question:
          'Después de vender y recolectar más material, ¿cuánto plástico y vidrio tiene Juan?',
      options: [
        '13 kg plástico • 27 kg vidrio',
        '20 kg plástico • 17 kg vidrio',
        '17 kg plástico • 20 kg vidrio',
        '13 kg plástico • 20 kg vidrio',
      ],
      correctIndex: 0,
    ),

    MathQuestion(
      level: 1,
      competency: 'Suma',
      topic: 'Residuos',
      question: '¿Cuánto se recolectó durante toda la semana?',
      options: ['35 kg', '38 kg', '40 kg', '42 kg'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Multiplicación',
      topic: 'Reciclaje',
      question:
          '¿Cuántos kilogramos de cartón necesitan para comprar el balón?',
      options: ['50 kg', '55 kg', '60 kg', '65 kg'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Suma',
      topic: 'Residuos peligrosos',
      question: 'Laura tiene 15 pilas y Samuel 9.',
      options: ['22', '23', '24', '25'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Multiplicación',
      topic: 'Reciclaje',
      question: '120 cajas con 9 botellas cada una.',
      options: ['980', '1080', '1200', '900'],
      correctIndex: 1,
    ),

    MathQuestion(
      level: 1,
      competency: 'Dinero',
      topic: 'Reciclaje',
      question: '¿Cuánto recibiría de cambio si hubiera pagado con \$20.000?',
      options: ['\$12.000', '\$13.000', '\$14.000', '\$15.000'],
      correctIndex: 1,
    ),

    MathQuestion(
      level: 1,
      competency: 'Resta',
      topic: 'Reciclaje',
      question: '¿Cuántos kilos deben dejar de producir?',
      options: ['10', '12', '15', '20'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'División',
      topic: 'Reutilización',
      question: '72 botellas entre 9 estudiantes.',
      options: ['6', '7', '8', '9'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Proporcionalidad',
      topic: 'Residuos',
      question: '¿Cuánto tiempo tardarán contando los 12 contenedores?',
      options: ['35 minutos', '42 minutos', '45 minutos', '48 minutos'],
      correctIndex: 2,
    ),

    MathQuestion(
      level: 1,
      competency: 'Resta',
      topic: 'Reutilización',
      question: 'Si faltan 250 metros y ya recorrieron 90 metros.',
      options: ['140', '150', '160', '170'],
      correctIndex: 2,
    ),
  ];

  // Agregado para soportar el nivel 2 usando las mismas preguntas por ahora
  static List<MathQuestion> level2 = List.from(level1);
}