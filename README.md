# Gilman News Project

App in development for local school newspaper. Currently has ability to interface with online database to display articles, images, and authors. Advanced Search Functionality has been implemented. User Stats have been implemented and store information on local device for simplicity. Recommended authors and following of specific author currently implemented. Read/unread articles implemented. roughly 3-4 years of articles (so 430) available currently. Two Games currently available - Curling (lol) and Gilman Connections. If interested in Beta Testing, reach out here: gilmannews@gilman.edu and I will get back to you.

Most Recent Update 7/13/26 - More Small fixes in preparation for android release. Also, it now works on the web.

Road Map:
2 More PLANNED updates (likely more):

1. late July 1.2.0 "mini" - Article of the day and some share features (if websites up). mainly QOL.
2. late August 1.3.0 - 1 New Game and greater caching and efficiency improvements

To view the code, got to lib/pages or lib/services.

For Baranano: The App Works on Web Now. the file system that needs to be overhauled is here: lib/services/stats/storage.dart
and here lib/services/stats/articlestorage.dart

Note\* because stats are stored locally, the stats only works for emulators or iphone/android themselves. This will be changes once I migrate old storage to the hive cache system.
