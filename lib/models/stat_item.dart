import 'package:covid_map/models/model.dart';



class StatItem extends Model {

    static String table = 'stat_items';

    int id;
    String country;
    String description;

    StatItem({ this.id, this.country, this.description});

    Map<String, dynamic> toMap() {

        Map<String, dynamic> map = {
            'country': country,
            'description': description,
        };

        if (id != null) { map['id'] = id; }
        return map;
    }

    static StatItem fromMap(Map<String, dynamic> map) {
        
        return StatItem(
            id: map['id'],
            country: map['country'],
            description: map['description'],

        );
    }
}