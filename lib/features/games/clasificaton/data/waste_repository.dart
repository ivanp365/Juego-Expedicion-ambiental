import '../models/waste_item.dart';

class WasteRepository {
  static const List<WasteItem> wastes = [
    // =====================
    // APROVECHABLES (Blanco)
    // =====================
    WasteItem(
      id: 'bolsa_plastica',
      name: 'Bolsa plástica',
      image: 'assets/images/clasificaton/waste/bolsa_plastica.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'botella_plastica',
      name: 'Botella plástica',
      image: 'assets/images/clasificaton/waste/botella_plastica.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'botella_vidrio',
      name: 'Botella de vidrio',
      image: 'assets/images/clasificaton/waste/botella_vidrio.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'caja_carton',
      name: 'Caja de cartón',
      image: 'assets/images/clasificaton/waste/caja_carton.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'envase_yogur',
      name: 'Envase de yogur',
      image: 'assets/images/clasificaton/waste/envase_yogur.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'periodico',
      name: 'Periódico',
      image: 'assets/images/clasificaton/waste/hojas_periodico.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'llanta',
      name: 'Llanta',
      image: 'assets/images/clasificaton/waste/llanta.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'olla',
      name: 'Olla',
      image: 'assets/images/clasificaton/waste/olla.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'revistas',
      name: 'Revistas',
      image: 'assets/images/clasificaton/waste/revistas.png',
      type: WasteType.recyclable,
    ),

    WasteItem(
      id: 'tapa_plastica',
      name: 'Tapa plástica',
      image: 'assets/images/clasificaton/waste/tapa_botella_plastica.png',
      type: WasteType.recyclable,
    ),

    // =====================
    // ORGÁNICOS (Verde)
    // =====================
    WasteItem(
      id: 'banano',
      name: 'Cáscara de banano',
      image: 'assets/images/clasificaton/waste/cascara_banano.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'huevo',
      name: 'Cáscara de huevo',
      image: 'assets/images/clasificaton/waste/cascara_huevo.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'verduras',
      name: 'Cáscara de verduras',
      image: 'assets/images/clasificaton/waste/cascara_verduras.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'espina',
      name: 'Espina de pescado',
      image: 'assets/images/clasificaton/waste/espina_pescado.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'estiercol',
      name: 'Estiércol',
      image: 'assets/images/clasificaton/waste/estiercol_vaca.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'fruta',
      name: 'Fruta en mal estado',
      image: 'assets/images/clasificaton/waste/fruta_mal_estado.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'hueso',
      name: 'Hueso de pollo',
      image: 'assets/images/clasificaton/waste/hueso_pollo.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'plumas',
      name: 'Plumas',
      image: 'assets/images/clasificaton/waste/plumas.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'comida',
      name: 'Restos de comida',
      image: 'assets/images/clasificaton/waste/restos_comida_cruda.png',
      type: WasteType.organic,
    ),

    WasteItem(
      id: 'cosecha',
      name: 'Restos de cosecha',
      image: 'assets/images/clasificaton/waste/restos_cosecha.png',
      type: WasteType.organic,
    ),

    // =====================
    // NO APROVECHABLES (Negro)
    // =====================
    WasteItem(
      id: 'vidrio_roto',
      name: 'Vidrio roto',
      image: 'assets/images/clasificaton/waste/botella_vidrio_rota.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'elementos_seguridad',
      name: 'Elementos de seguridad',
      image: 'assets/images/clasificaton/waste/elementos_seguridad.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'empaque',
      name: 'Empaque',
      image: 'assets/images/clasificaton/waste/empaque_producto.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'lapiceros',
      name: 'Lapiceros',
      image: 'assets/images/clasificaton/waste/lapiceros.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'panales',
      name: 'Pañales',
      image: 'assets/images/clasificaton/waste/panales_desechables.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'salchipapa',
      name: 'Plato de salchipapa',
      image: 'assets/images/clasificaton/waste/plato_salchipapa.png',
      type: WasteType.nonRecyclable,
    ),

    WasteItem(
      id: 'barrido',
      name: 'Residuos de barrido',
      image: 'assets/images/clasificaton/waste/residuos_barrido.png',
      type: WasteType.nonRecyclable,
    ),

    // =====================
    // PELIGROSOS (Rojo)
    // =====================
    WasteItem(
      id: 'bombillos',
      name: 'Bombillos',
      image: 'assets/images/clasificaton/waste/bombillos.png',
      type: WasteType.hazardous,
    ),

    WasteItem(
      id: 'electronicos',
      name: 'Equipos electrónicos',
      image: 'assets/images/clasificaton/waste/equipos_electronicos.png',
      type: WasteType.hazardous,
    ),

    WasteItem(
      id: 'medicamentos',
      name: 'Medicamentos',
      image: 'assets/images/clasificaton/waste/medicamentos.png',
      type: WasteType.hazardous,
    ),

    WasteItem(
      id: 'pilas',
      name: 'Pilas',
      image: 'assets/images/clasificaton/waste/pilas.png',
      type: WasteType.hazardous,
    ),

    WasteItem(
      id: 'recipientes_agroquimicos',
      name: 'Recipientes de agroquímicos',
      image: 'assets/images/clasificaton/waste/recipientes_agroquimicos.png',
      type: WasteType.hazardous,
    ),

    WasteItem(
      id: 'residuos_agroquimicos',
      name: 'Residuos de agroquímicos',
      image: 'assets/images/clasificaton/waste/residuos_agroquimicos.png',
      type: WasteType.hazardous,
    ),
  ];

  /// Retorna una nueva lista mutable con todos los residuos, ideal para
  /// poder desordenar (shuffle) la lista sin modificar la constante original.
  static List<WasteItem> getItems() {
    return List.of(wastes);
  }
}
