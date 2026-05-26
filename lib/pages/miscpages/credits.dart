import 'package:The_Gilman_News/pages/articlepages/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreditsPage extends StatelessWidget {
  // About Page Stateless
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<LicenseEntry>> getlicenses() async {
      List<LicenseEntry> individualentries = [];
      Map<String, List> entry_map = {};
      await for (final license in LicenseRegistry.licenses) {
        final paragraphs = license.paragraphs.map((p) => p.text).join("\n");
        final normalparagraphs = paragraphs
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '')
            .replaceAll(RegExp(r'[^\w]'), '');
        if (normalparagraphs.isEmpty) continue;

        if (entry_map.containsKey(normalparagraphs)) {
          entry_map[paragraphs]!.addAll(license.packages);
        } else {
          entry_map[paragraphs] = license.packages.toList();
          individualentries.add(license);
        }
      }
      return individualentries.map((entry) {
        String entryparagraphs = entry.paragraphs.map((p) => p.text).join("\n");
        return LicenseEntryWithLineBreaks(
          entry_map[entryparagraphs]!.toSet().toList() as List<String>,
          entryparagraphs,
        );
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(35, 150, 35, 0),
                    child: Text(
                      style: GoogleFonts.lora(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      "Licenses",
                    ),
                  ),
                ),
              ),
              floating: true,
              forceElevated: true,
              pinned: true,

              elevation: 4.0,
              shadowColor: const Color.fromARGB(255, 0, 0, 0),
              expandedHeight: 100,
              collapsedHeight: 40,
              toolbarHeight: 40,
            ),
          ];
        },
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: .5, maxScaleFactor: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
            child: FutureBuilder(
              future: getlicenses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    !snapshot.hasData) {
                  return Center(
                    child: SpinKitCircle(
                      color: const Color.fromARGB(255, 7, 56, 80),
                    ),
                  );
                }
                final List<LicenseEntry> licenses = snapshot.data ?? [];

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  itemCount: licenses.length,
                  itemBuilder: (context, object) {
                    final licencse = licenses[object];
                    final name = licencse.packages.join(", ");
                    final paragraph = licencse.paragraphs
                        .map((p) => p.text)
                        .join("\n  ");
                    return ExpansionTile(
                      title: Text(name),
                      subtitle: Text("View License"),
                      children: [Text(paragraph)],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
