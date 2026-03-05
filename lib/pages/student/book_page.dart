import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../constants/app_colors.dart';
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

  final List<BookModel> _books = [
    BookModel(
      id: '1',
      title: 'Inson qidiruvi',
      author: 'Viktor Frankl',
      startDate: DateTime(2026, 1, 5),
      endDate: DateTime(2026, 1, 25),
      status: BookStatus.tugatdim,
      coverUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200',
      summary: "Yozuvchi o'zining konslager tajribasidan kelib chiqqan holda, insonning ma'noga bo'lgan ehtiyojini va hayotdagi maqsadni topishning muhimligini tushuntiradi.",
    ),
    BookModel(
      id: '2',
      title: 'Atom odatlar',
      author: 'James Clear',
      startDate: DateTime(2026, 1, 28),
      endDate: DateTime(2026, 2, 8),
      status: BookStatus.tugatdim,
      coverUrl: 'https://images.unsplash.com/photo-1589998059171-988d887df646?w=200',
      summary: "Kichik o'zgarishlar qanday qilib katta natijalarga olib kelishini tushuntiruvchi amaliy qo'llanma.",
    ),
    BookModel(
      id: '3',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      startDate: DateTime(2026, 2, 1),
      status: BookStatus.oqiyapman,
      coverUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=200',
      summary: "Dasturchilar uchun eng muhim kitoblardan biri. Toza, tushunarli va samarali kod yozish tamoyillari.",
    ),
  ];

  // ── Getters ──────────────────────────────────
  List<BookModel> get _filtered {
    switch (_tabController.index) {
      case 1: return _books.where((b) => b.status == BookStatus.oqiyapman).toList();
      case 2: return _books.where((b) => b.status == BookStatus.tugatdim).toList();
      default: return List.from(_books);
    }
  }

  int get _oqiyapman => _books.where((b) => b.status == BookStatus.oqiyapman).length;
  int get _tugatdim  => _books.where((b) => b.status == BookStatus.tugatdim).length;

  // ── Lifecycle ────────────────────────────────
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Actions ──────────────────────────────────
  void _openEdit({BookModel? book}) {
    showDialog(
      context: context,
      builder: (_) => BookEditDialog(
        book: book,
        onSave: (saved) => setState(() {
          if (book == null) {
            _books.add(saved);
          } else {
            final i = _books.indexWhere((b) => b.id == saved.id);
            if (i != -1) _books[i] = saved;
          }
        }),
      ),
    );
  }

  void _openDelete(BookModel book) {
    showDialog(
      context: context,
      builder: (_) => BookDeleteDialog(
        book: book,
        onConfirm: () => setState(() => _books.removeWhere((b) => b.id == book.id)),
      ),
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildStats()),
              SliverToBoxAdapter(child: _buildTabsRow()),
              _isListView
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => BookListItem(
                    book: _filtered[i],
                    onEdit: () => _openEdit(book: _filtered[i]),
                    onDelete: () => _openDelete(_filtered[i]),
                  ),
                  childCount: _filtered.length,
                ),
              )
                  : SliverPadding(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ]),
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
        Expanded(child: BookStatCard(
          label: "O'qib tugatdim",
          count: _tugatdim,
          color: AppColors.green,
          icon: Icons.check_circle_outline,
          small: true,
        )),
        const SizedBox(width: 10),
        Expanded(child: BookStatCard(
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
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          tabs: [
            Tab(child: Text('Hammasi\n(${_books.length})', textAlign: TextAlign.center,
                maxLines: 2, style: const TextStyle(height: 1.2))),
            Tab(child: Text("O'qiyapman\n($_oqiyapman)", textAlign: TextAlign.center,
                maxLines: 2, style: const TextStyle(height: 1.2))),
            Tab(child: Text('Tugatdim\n($_tugatdim)', textAlign: TextAlign.center,
                maxLines: 2, style: const TextStyle(height: 1.2))),
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
      child: Icon(icon, size: 18, color: active ? Colors.white : Colors.grey),
    ),
  );
}