enum BillingStatus { pending, paid, overdue, cancelled }
enum PaymentMethod { cash, card, insurance, bank_transfer }

class BillItem {
  final String description;
  final double amount;
  final int quantity;
  final String? code;

  BillItem({
    required this.description,
    required this.amount,
    required this.quantity,
    this.code,
  });

  double get total => amount * quantity;

  
    'description': description,
    'amount': amount,
    'quantity': quantity,
    'code': code,
    'total': total,
  };

  
    description: json['description'] as String,
    amount: json['amount'] as double,
    quantity: json['quantity'] as int,
    code: json['code'] as String?,
  );
}

class Bill {
  final String id;
  final String patientId;
  final String appointmentId;
  final String clinicId;
  final List<BillItem> items;
  final double discount;
  final double tax;
  final BillingStatus status;
  final PaymentMethod? paymentMethod;
  final DateTime issuedAt;
  final DateTime? paidAt;
  final String? notes;

  Bill({
    required this.id,
    required this.patientId,
    required this.appointmentId,
    required this.clinicId,
    required this.items,
    this.discount = 0,
    this.tax = 0,
    required this.status,
    this.paymentMethod,
    required this.issuedAt,
    this.paidAt,
    this.notes,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal - discount + tax;

  
    'id': id,
    'patient_id': patientId,
    'appointment_id': appointmentId,
    'clinic_id': clinicId,
    'items': items.map((i) => i.toJson()).toList(),
    'discount': discount,
    'tax': tax,
    'subtotal': subtotal,
    'total': total,
    'status': status.toString().split('.').last,
    'payment_method': paymentMethod?.toString().split('.').last,
    'issued_at': issuedAt.toIso8601String(),
    'paid_at': paidAt?.toIso8601String(),
    'notes': notes,
  };

  
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    appointmentId: json['appointment_id'] as String,
    clinicId: json['clinic_id'] as String,
    items: (json['items'] as List)
        .map((i) => BillItem.fromJson(i as Map<String, dynamic>))
        .toList(),
    discount: json['discount'] as double? ?? 0,
    tax: json['tax'] as double? ?? 0,
    status: BillingStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
    ),
    paymentMethod: json['payment_method'] != null
        ? PaymentMethod.values.firstWhere(
            (e) => e.toString().split('.').last == json['payment_method'],
          )
        : null,
    issuedAt: DateTime.parse(json['issued_at'] as String),
    paidAt: json['paid_at'] != null
        ? DateTime.parse(json['paid_at'] as String)
        : null,
    notes: json['notes'] as String?,
  );
}
