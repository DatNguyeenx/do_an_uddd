import '../models/comment.dart';

List<Comment> sampleComments = [
  Comment(
    id: 'c1',
    postId: '1',
    author: 'Minh Tuấn',
    content:
        'Bài viết rất chi tiết! Ti Tốp chèo Kayak buổi chiều tầm 3-4h là mát nhất luôn.',
    date: '10/09/2026',
    likeCount: 5,
    replies: [
      Comment(
        id: 'c1_1',
        postId: '1',
        parentId: 'c1',
        author: 'Hoàng Nam',
        content:
            'Cảm ơn bạn nhé! Đúng rồi, đi tầm đó nắng dịu chụp hình lại đẹp nữa.',
        date: '10/09/2026',
        likeCount: 2,
      ),
    ],
  ),
  Comment(
    id: 'c2',
    postId: '1',
    author: 'Thảo Nguyên',
    content: 'Cho mình hỏi chi phí thuê thuyền Kayak khoảng bao nhiêu vậy ạ?',
    date: '10/09/2026',
    likeCount: 1,
  ),
  Comment(
    id: 'c3',
    postId: '2',
    author: 'Khánh Linh',
    content:
        'Mấy quán ở Cầu Đất săn mây đỉnh thật nhưng đường đi sáng sớm hơi sương mù, mọi người nhớ chạy chậm nha.',
    date: '09/09/2026',
    likeCount: 8,
  ),
  Comment(
    id: 'c4',
    postId: '2',
    author: 'Gia Bảo',
    content:
        'Quán cà phê hoàng hôn Thái Phiên chill cực kỳ, uống trà atiso nóng hợp bài lắm.',
    date: '09/09/2026',
    likeCount: 3,
  ),
  Comment(
    id: 'c5',
    postId: '3',
    author: 'Đức Huy',
    content:
        'Đến Hội An nhất định phải thử nước Mót nha mọi người, uống thanh mát dã dăm!',
    date: '06/09/2026',
    likeCount: 12,
  ),
  Comment(
    id: 'c6',
    postId: '4',
    author: 'Hoàng Yến',
    content:
        'Đúng chuẩn người Hà Nội rồi, nước dùng trong và ngọt thanh chứ không bỏ nhiều đường.',
    date: '08/09/2026',
    likeCount: 15,
  ),
  Comment(
    id: 'c7',
    postId: '4',
    author: 'Quốc Bảo',
    content:
        'Ăn phở tái nạm thêm cái quẩy giòn nhúng vào nước dùng là số dzách!',
    date: '09/09/2026',
    likeCount: 4,
  ),
  Comment(
    id: 'c8',
    postId: '5',
    author: 'Tuấn Anh',
    content:
        'Lên Mẫu Sơn mùa đông lạnh thấu xương nhưng cảnh đẹp như trời Âu luôn.',
    date: '10/09/2026',
    likeCount: 6,
  ),
  Comment(
    id: 'c9',
    postId: '6',
    author: 'Thanh Hằng',
    content:
        'Mẹo cuộn tròn quần áo cứu mình mấy bàn thua trông thấy khi đi balo gọn nhẹ đấy.',
    date: '07/09/2026',
    likeCount: 9,
  ),
  Comment(
    id: 'c10',
    postId: '7',
    author: 'Cẩm Tú',
    content:
        'Bún quậy Kiến Xây ăn lạ miệng mà ngon nha, nước chấm tự pha theo ý thích rất cuốn.',
    date: '05/09/2026',
    likeCount: 7,
  ),
  Comment(
    id: 'c11',
    postId: '8',
    author: 'Minh Trí',
    content:
        'Leo 500 bậc ở Hang Múa hơi mệt nhưng view nhìn xuống thung lũng Tam Cốc đẹp miễn bàn!',
    date: '04/09/2026',
    likeCount: 11,
  ),
  Comment(
    id: 'c12',
    postId: '9',
    author: 'Đăng Khoa',
    content:
        'Kê Gà bình minh đẹp hoang sơ, cắm trại qua đêm nghe tiếng sóng vỗ rất thích.',
    date: '03/09/2026',
    likeCount: 4,
  ),
  Comment(
    id: 'c13',
    postId: '10',
    author: 'Bảo Ngọc',
    content:
        'Phá lấu bò khu chợ Tân Định là chân ái cuộc đời mình, chiều nào cũng thèm.',
    date: '02/09/2026',
    likeCount: 14,
  ),
  Comment(
    id: 'c14',
    postId: '11',
    author: 'Thu Hà',
    content:
        'Sống lưng khủng long đi thốn tim thật nhưng lúc săn được mây thì mãn nguyện cực kỳ.',
    date: '01/09/2026',
    likeCount: 10,
  ),
  Comment(
    id: 'c15',
    postId: '12',
    author: 'Phương Thảo',
    content:
        'Nhìn dĩa rau đồng ăn kèm với bông điên điển là thèm thuồng hương vị miền Tây rồi.',
    date: '31/08/2026',
    likeCount: 6,
  ),
  Comment(
    id: 'c16',
    postId: '13',
    author: 'Ngọc Bích',
    content:
        'Đường Lâm yên bình lắm, đạp xe ngắm tường đá ong cảm giác chậm lại hẳn.',
    date: '29/08/2026',
    likeCount: 5,
  ),
  Comment(
    id: 'c17',
    postId: '14',
    author: 'Thái Sơn',
    content:
        'Cảm ơn thớt nhiều, áp thử mẹo đặt vé bay đêm tiết kiệm được khoản lớn thật.',
    date: '27/08/2026',
    likeCount: 18,
    replies: [
      Comment(
        id: 'c17_1',
        postId: '14',
        parentId: 'c17',
        author: 'Khánh Linh',
        content:
            'Chuẩn luôn bạn ơi, canh khung giờ vàng đêm khuya hay có deal hời lắm.',
        date: '27/08/2026',
        likeCount: 3,
      ),
    ],
  ),
  Comment(
    id: 'c18',
    postId: '15',
    author: 'Minh Tuấn',
    content:
        'Sườn nướng mật ong thơm phức thêm miếng chả trứng béo ngậy là nhức nách.',
    date: '26/08/2026',
    likeCount: 9,
  ),
  Comment(
    id: 'c19',
    postId: '16',
    author: 'Đức Huy',
    content:
        'Nước biển ở Đảo Bé trong veo thấy cả đáy, lặn ngắm san hô cực đã.',
    date: '24/08/2026',
    likeCount: 7,
  ),
  Comment(
    id: 'c20',
    postId: '17',
    author: 'Hoàng Nam',
    content: 'Bánh mì Việt Nam số một thế giới là hoàn toàn xứng đáng luôn.',
    date: '21/08/2026',
    likeCount: 20,
  ),
  Comment(
    id: 'c21',
    postId: '18',
    author: 'Gia Bảo',
    content:
        'Sông Nho Quế xanh ngọc bích chèo thuyền thấm mệt nhưng cảnh siêu thực.',
    date: '19/08/2026',
    likeCount: 13,
  ),
  Comment(
    id: 'c22',
    postId: '19',
    author: 'Thanh Hằng',
    content:
        'Trải nghiệm làm nông dân tưới rau xong ăn bánh xèo tôm nhảy ngon xuất sắc.',
    date: '16/08/2026',
    likeCount: 6,
  ),
  Comment(
    id: 'c23',
    postId: '20',
    author: 'Cẩm Tú',
    content:
        'Kinh nghiệm xương máu là cứ chọn tầng dưới dãy giữa đỡ xóc hẳn mọi người ạ.',
    date: '13/08/2026',
    likeCount: 12,
  ),
];
