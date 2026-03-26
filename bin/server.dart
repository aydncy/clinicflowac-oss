router.get('/verify-key', (Request req) async {
  final key = req.url.queryParameters['key'];

  final result = await db.query(
    "SELECT email, usage_count, plan FROM api_keys WHERE api_key=@k",
    substitutionValues: {'k': key},
  );

  if (result.isEmpty) {
    return Response.forbidden('invalid');
  }

  final row = result.first;
  final email = row[0] as String;
  final usage = (row[1] as int) + 1;
  final plan = row[2] as String;

  final limit = plan == 'pro' ? 1000 : 5;

  await db.query(
    "UPDATE api_keys SET usage_count=@u WHERE api_key=@k",
    substitutionValues: {'u': usage, 'k': key},
  );

  await db.query(
    "INSERT INTO events (email, event_type, usage) VALUES (@e, 'request', @u)",
    substitutionValues: {'e': email, 'u': usage},
  );

  if (usage > limit) {
    await db.query(
      "INSERT INTO events (email, event_type, usage) VALUES (@e, 'limit_reached', @u)",
      substitutionValues: {'e': email, 'u': usage},
    );

    final upgradeUrl =
        "https://gumroad.com/l/ovwi"
        "?email=$email"
        "&key=$key"
        "&usage=$usage";

    return Response.redirect(Uri.parse(upgradeUrl), statusCode: 302);
  }

  return Response.ok('ok');
});