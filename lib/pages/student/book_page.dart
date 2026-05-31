import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../constants/app_colors.dart';
import '../../services/book_service.dart';
import '../../services/student_service.dart';
import '../../widgets/students/books/book_delete_dialog.dart';
import '../../widgets/students/books/book_edit_dialog.dart';
import '../../widgets/students/books/book_grid_item.dart';
import '../../widgets/students/books/book_list_item.dart';
import '../../widgets/students/books/book_stat_card.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isListView = true;
  bool _loading = true;
  int? _studentId;

  final _bookService = BookService();
  final _studentService = StudentService();
  List<BookModel> _books = [];

  List<BookModel> get _filtered {
    switch (_tabController.index) {
      case 1:
        return _books.where((b) => b.status == BookStatus.oqiyapman).toList();
      case 2:
        return _books.where((b) => b.status == BookStatus.tugatdim).toList();
      default:
        return List.from(_books);
    }
  }

  int get _oqiyapman =>
      _books.where((b) => b.status == BookStatus.oqiyapman).length;
  int get _tugatdim =>
      _books.where((b) => b.status == BookStatus.tugatdim).length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final profile = await _studentService.fetchProfile();
    if (profile == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    _studentId = profile.id;
    final books = await _bookService.fetchMyBooks(profile.id);
    if (!mounted) return;
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.red : AppColors.green,
    ));
  }

  void _openEdit({BookModel? book}) {
    showDialog(
      context: context,
      builder: (_) => BookEditDialog(
        book: book,
        onSave: (saved) async {
          final sid = _studentId;
          if (sid == null) return;
          if (book == null) {
            final created = await _bookService.createBook(saved, studentId: sid);
            if (created != null) {
              await _load();
              _snack('Kitob qo\'shildi');
            } else {
              _snack('Saqlashda xatolik', error: true);
            }
          } else {
            final ok = await _bookService.updateBook(saved, studentId: sid);
            if (ok) {
              await _load();
              _snack('Kitob yangilandi');
            } else {
              _snack('Saqlashda xatolik', error: true);
            }
          }
        },
      ),
    );
  }

  void _openDelete(BookModel book) {
    showDialog(
      context: context,
      builder: (_) => BookDeleteDialog(
        book: book,
        onConfirm: () async {
          final ok = await _bookService.deleteBook(book.id);
          if (ok) {
            await _load();
            _snack('Kitob o\'chirildi');
          } else {
            _snack('O\'chirishda xatolik', error: true);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.scaffold,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildStats()),
                  SliverToBoxAdapter(child: _buildTabsRow()),
                  if (_filtered.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Kitoblar topilmadi',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else if (_isListView)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => BookListItem(
                          book: _filtered[i],
                          onEdit: () => _openEdit(book: _filtered[i]),
                          onDelete: () => _openDelete(_filtered[i]),
                        ),
                        childCount: _filtered.length,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => BookGridItem(
                            book: _filtered[i],
                            onEdit: () => _openEdit(book: _filtered[i]),
                            onDelete: () => _openDelete(_filtered[i]),
                          ),
                          childCount: _filtered.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Kitoblarim',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            const Text('📚', style: TextStyle(fontSize: 22)),
          ]),
          const SizedBox(height: 2),
          Text("O'qigan kitoblarim va jarayondagilar",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ]),
      );

  Widget _buildStats() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          BookStatCard(
            label: 'Jami Kitoblar',
            count: _books.length,
            color: AppColors.purple,
            icon: Icons.menu_book_rounded,
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: BookStatCard(
              label: "O'qib tugatdim",
              count: _tugatdim,
              color: AppColors.green,
              icon: Icons.check_circle_outline,
              small: true,
            )),
            const SizedBox(width: 10),
            Expanded(
                child: BookStatCard(
              label: "O'qiyapman",
              count: _oqiyapman,
              color: AppColors.blue,
              icon: Icons.auto_stories_outlined,
              small: true,
            )),
          ]),
        ]),
      );

  Widget _buildTabsRow() => Container(
        color: AppColors.scaffold,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              tabs: [
                Tab(
                    child: Text('Hammasi\n(${_books.length})',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(height: 1.2))),
                Tab(
                    child: Text("O'qiyapman\n($_oqiyapman)",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(height: 1.2))),
                Tab(
                    child: Text('Tugatdim\n($_tugatdim)',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(height: 1.2))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(children: [
              _toggleBtn(Icons.grid_view, !_isListView),
              _toggleBtn(Icons.list, _isListView),
            ]),
          ),
        ]),
      );

  Widget _toggleBtn(IconData icon, bool active) => GestureDetector(
        onTap: () => setState(() => _isListView = icon == Icons.list),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon,
              size: 18, color: active ? Colors.white : Colors.grey),
        ),
      );
}
