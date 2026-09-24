class Post {
  final String id;
  final String title;
  final String author;
  final String date;
  final String summary;
  final String content;
  final List<String> categories;

  bool isLiked;
  int likeCount;
  bool isBookMarked;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.summary,
    required this.content,
    required this.categories,
    this.isLiked = false,
    this.likeCount = 124,
    this.isBookMarked = false,
  });
<<<<<<< HEAD

  factory Post.fromJson(Map<String, dynamic> json) {
    // Đọc danh sách categories hoặc tags từ Supabase
    List<String> parsedCategories = [];
    if (json['categories'] != null) {
      parsedCategories = List<String>.from(json['categories']);
    } else if (json['tags'] != null) {
      parsedCategories = List<String>.from(json['tags']);
    }

    return Post(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      categories: parsedCategories,
      isLiked: json['is_liked'] ?? json['isLiked'] ?? false,
      likeCount: json['like_count'] ?? json['likeCount'] ?? 0,
      isBookMarked: json['is_bookmarked'] ?? json['isBookMarked'] ?? false,
    );
  }
}
=======
}

List<Post> samplePosts = [
  Post(
    id: '1',
    title: 'Kinh nghiệm du lịch Vịnh Hạ Long tự túc từ A-Z',
    author: 'Hoàng Nam',
    date: '10/09/2026',
    summary:
        'Chia sẻ chi tiết lịch trình 2 ngày 1 đêm khám phá Vịnh Hạ Long tối ưu chi phí.',
    content:
        'Vịnh Hạ Long luôn là điểm đến hấp dẫn du khách trong và ngoài nước nhờ vẻ đẹp kỳ vĩ của hàng ngàn đảo đá vôi nhấp nhô trên làn nước xanh ngọc bích. Để có một chuyến đi trọn vẹn, bạn nên đặt trước vé tàu du thuyền ghé thăm các danh thắng nổi tiếng như Hang Sửng Sốt, Đảo Ti Tốp và Hang Luồn. Buổi chiều là thời điểm lý tưởng nhất để trải nghiệm chèo thuyền Kayak xuyên qua các vòm đá tự nhiên. Đừng quên thưởng thức các món hải sản tươi sống đặc trưng như chả mực giã tay, bề bề hấp sả và sam biển tại khu vực Bãi Cháy.',
    categories: ['Kinh nghiệm', 'Địa điểm'],
  ),
  Post(
    id: '2',
    title: 'Top 5 quán cà phê view đẹp không thể bỏ qua tại Đà Lạt',
    author: 'Phương Thảo',
    date: '08/09/2026',
    summary:
        'Tổng hợp danh sách những quán cà phê ngắm hoàng hôn và săn mây cực đỉnh.',
    content:
        'Đà Lạt không chỉ thu hút bởi khí hậu mát mẻ quanh năm mà còn bởi những góc cà phê ngập tràn sắc hoa và sương mờ. Đầu tiên phải kể đến các không gian cà phê săn mây nằm trên đồi cao ở Cầu Đất, nơi bạn có thể ngắm trọn biển mây bồng bềnh lúc 5 giờ sáng. Tiếp theo là những quán cà phê phong cách hoàng hôn lung linh ánh đèn tại làng hoa Thái Phiên. Khi ghé thăm, hãy thử thưởng thức một tách trà atiso nóng hoặc cà phê trứng đặc sánh giữa thời tiết se lạnh để cảm nhận trọn vẹn không khí yên bình đặc trưng của vùng đất cao nguyên này.',
    categories: ['Địa điểm', 'Kinh nghiệm'],
  ),
  Post(
    id: '3',
    title: 'Khám phá ẩm thực Phố cổ Hội An về đêm',
    author: 'Minh Nhật',
    date: '05/09/2026',
    summary:
        'Thưởng thức Cao Lầu, Mì Quảng, Cơm gà và nước Mót trong không gian đèn lồng rực rỡ.',
    content:
        'Khi màn đêm buông xuống, Phố cổ Hội An khoác lên mình vẻ đẹp lung linh bí ẩn dưới ánh sáng của hàng ngàn chiếc đèn lồng đủ màu sắc. Đây cũng là thời điểm tuyệt vời nhất để bắt đầu chuyến tản bộ thưởng thức ẩm thực đường phố. Bắt đầu hành trình với một bát Cao Lầu đậm đà sợi mì dai giòn, tiếp tục ghé quán Cơm gà xé phay giòn thơm và không thể bỏ qua ly nước Mót thảo mộc thanh mát nổi tiếng. Cuối cùng, hãy khép lại buổi tối bằng việc ngồi thuyền hoa đăng trên dòng sông Hoài thơ mộng.',
    categories: ['Ẩm thực', 'Địa điểm'],
  ),
  Post(
    id: '4',
    title: 'Bí quyết thưởng thức trọn vẹn hương vị Phở Bò Hà Nội truyền thống',
    author: 'Thu Hà',
    date: '08/09/2026',
    summary:
        'Khám phá sự tinh tế trong cách nấu nước dùng thanh ngọt và nét văn hóa thưởng thức phở của người Tràng An.',
    content:
        'Phở Bò Hà Nội từ lâu đã trở thành biểu tượng ẩm thực không thể thay thế trong lòng người dân Việt Nam và bạn bè quốc tế. Sự tinh túy của bát phở nằm ở phần nước dùng trong vắt, ngọt tự nhiên từ xương ống bò ninh liên tục suốt 10-12 tiếng cùng các gia vị thảo mộc như hồi, quế, thảo quả và gừng nướng. Khi thưởng thức, người Hà Nội thường ăn kèm quẩy giòn tan, thêm chút ớt xào thơm nồng và giấm tỏi thanh nhẹ chứ không dùng quá nhiều tương đen hay tương ớt ngọt như miền Nam.',
    categories: ['Ẩm thực', 'Kinh nghiệm'],
  ),
  Post(
    id: '5',
    title: 'Chinh phục đỉnh Mẫu Sơn: Điểm săn mây và băng tuyết lý tưởng',
    author: 'Bảo Khánh',
    date: '09/09/2026',
    summary:
        'Hành trình khám phá vùng núi cao Lạng Sơn với không khí trong lành và kiến trúc Pháp cổ.',
    content:
        'Nằm ở độ cao hơn 1.000m so với mực nước biển, Mẫu Sơn (Lạng Sơn) được thiên nhiên ưu ái ban tặng không khí mát mẻ quanh năm và là một trong số ít nơi tại Việt Nam xuất hiện băng tuyết vào mùa đông. Đường lên đỉnh Mẫu Sơn uốn lượn qua những cánh rừng nguyên sinh và các biệt thự đồi cổ thời Pháp thuộc. Tại đây, bạn có thể cắm trại qua đêm để đón bình minh trên mây, tìm hiểu nét văn hóa độc đáo của đồng bào dân tộc Dao và thưởng thức các đặc sản địa phương như lợn quay lá mắc mật, chè tuyết sơn.',
    categories: ['Địa điểm'],
  ),
  Post(
    id: '6',
    title: 'Hướng dẫn chuẩn bị hành lý du lịch bụi ngắn ngày tối ưu nhất',
    author: 'Tuấn Anh',
    date: '07/09/2026',
    summary:
        'Mẹo xếp đồ thông minh giúp bạn vi vu 3 ngày 2 đêm chỉ với một chiếc balo duy nhất.',
    content:
        'Kỹ năng đóng gói hành lý gọn nhẹ là yếu tố quyết định sự thoải mái cho mỗi chuyến đi phượt. Bạn nên ưu tiên chọn các trang phục chất liệu thoáng khí, dễ khô và phối đồ theo nguyên tắc layer. Thay vì gấp áo quần theo cách truyền thống, hãy cuộn tròn chặt tay để tiết kiệm diện tích và tránh bị nhăn. Ngoài ra, hãy chuẩn bị các hũ chiết mỹ phẩm dung tích nhỏ dưới 100ml, một túi trang bị y tế cá nhân cơ bản và luôn mang theo pin sạc dự phòng dung lượng cao.',
    categories: ['Kinh nghiệm'],
  ),
  Post(
    id: '7',
    title: 'Lạc bước ở Chợ đêm Phú Quốc: Thiên đường hải sản tươi sống',
    author: 'Thanh Hằng',
    date: '04/09/2026',
    summary:
        'Trải nghiệm không gian sầm uất và cẩm nang ăn uống không lo bị chặt chém tại đảo Ngọc.',
    content:
        'Chợ đêm Phú Quốc là tọa độ không thể bỏ qua đối với những tâm hồn mê ẩm thực biển. Ngay từ khi bước vào cổng chợ, bạn sẽ bị cuốn hút bởi mùi thơm nức đến từ các gian hàng nướng than hồng. Đừng bỏ lỡ cơ hội thưởng thức bún quậy Kiến Xây độc đáo, ghẹ Hàm Ninh thịt chắc ngọt, nhum biển nướng mỡ hành thơm béo và kẹo chỉ tơ phong cách Pháp. Lưu ý nhỏ là bạn nên tham khảo giá niêm yết tại các gian hàng trước khi gọi món nhé.',
    categories: ['Ẩm thực'],
  ),
  Post(
    id: '8',
    title:
        'Lịch trình trọn gói khám phá Ninh Bình: Tràng An - Hang Múa 2 ngày 1 đêm',
    author: 'Đức Huy',
    date: '03/09/2026',
    summary:
        'Chi tiết tuyến đường tham quan danh thắng di sản thiên nhiên thế giới Bái Đính - Tràng An.',
    content:
        'Ninh Bình nổi tiếng với vẻ đẹp sơn thủy hữu tình được ví như Hạ Long trên cạn. Ngày thứ nhất, bạn hãy dành trọn buổi sáng ngồi thuyền rồng lướt trên dòng sông Sào Khê xuyên qua các hang động kỳ bí ở danh thắng Tràng An, sau đó thử thách bản thân leo 500 bậc đá lên đỉnh Hang Múa ngắm toàn cảnh cánh đồng lúa Tam Cốc. Sang ngày thứ hai, hãy ghé thăm cố đô Hoa Lư để dâng hương và tìm hiểu lịch sử các triều đại Đinh - Lê. Đừng quên nạp năng lượng bằng các món cơm cháy giòn rụm và thịt dê núi tái chanh.',
    categories: ['Kinh nghiệm', 'Ẩm thực', 'Địa điểm'],
  ),
  Post(
    id: '9',
    title: 'Trải nghiệm cắm trại đón bình minh tại Biển Kê Gà Bình Thuận',
    author: 'Ngọc Bích',
    date: '02/09/2026',
    summary: 'Đón những tia nắng đầu tiên bên ngọn hải đăng cổ nhất Việt Nam.',
    content:
        'Mũi Kê Gà thu hút các tín đồ xô dịch nhờ vẻ đẹp hoang sơ với những bãi đá nhảy có hình thù kỳ lạ xếp chồng lên nhau ra tận mép sóng. Bạn có thể dựng lều cắm trại ngay trên bãi cát mịn, đốt lửa trại nướng hải sản cùng bạn bè dưới bầu trời sao đêm rực rỡ. Rạng sáng là khoảnh khắc tuyệt vời nhất khi mặt trời đỏ rực ngoi lên từ lòng đại dương, chiếu sáng ngọn hải đăng Kê Gà sừng sững gieo nên một bức tranh thiên nhiên tuyệt đẹp.',
    categories: ['Địa điểm'],
  ),
  Post(
    id: '10',
    title: 'Bí quyết lùng quét các món ăn vặt Sài Gòn chuẩn vị chợ cũ',
    author: 'Gia Bảo',
    date: '01/09/2026',
    summary:
        'Điểm danh những hẻm ăn vặt lâu đời trứ danh tại Quận 1, Quận 3 và Quận 5.',
    content:
        'Ẩm thực đường phố Sài Gòn luôn sống động và đa dạng sắc màu văn hóa. Bắt đầu từ những chiếc bánh mì chảo thơm nức mũi vào buổi sáng, tiếp nối buổi chiều bằng tô phá lấu bò chấm bánh mì giòn tan đậm đà cốt dừa tại khu chợ Tân Định. Khi phố xá lên đèn, hãy cùng hội bạn rủ rê ra hẻm ăn vặt xông xáo đĩa bột chiên giòn rụm, tráng miệng bằng chén chè mâm 16 món phong cách Nam Bộ. Đây chắc chắn là trải nghiệm vị giác không thể nào quên.',
    categories: ['Ẩm thực', 'Kinh nghiệm'],
  ),
  Post(
    id: '11',
    title: 'Hành trình trèo đèo vượt dốc chinh phục đỉnh Tà Xùa',
    author: 'Quang Vinh',
    date: '31/08/2026',
    summary:
        'Kinh nghiệm trekking sống lưng khủng long và bí quyết săn đại dương mây Sơn La.',
    content:
        'Tà Xùa (Bắc Yên, Sơn La) được ví như thiên đường mây của miền Bắc. Để chinh phục được Sống lưng khủng long Háng Đồng, bạn cần chuẩn bị thể lực tốt và kỹ năng leo núi cơ bản. Đoạn đường hiểm trở nhưng phần thưởng nhận lại vô cùng xứng đáng: một đại dương mây trắng xóa cuộn trào ngay dưới chân bạn khi bình minh vừa hé rạng. Hãy nhớ mang theo trang phục giữ ấm tốt vì nhiệt độ ban đêm trên đỉnh núi xuống rất thấp.',
    categories: ['Địa điểm', 'Kinh nghiệm'],
  ),
  Post(
    id: '12',
    title: 'Cẩm nang thưởng thức Bún Mắm Miền Tây chuẩn vị Cần Thơ',
    author: 'Cẩm Tú',
    date: '30/08/2026',
    summary:
        'Sự kết hợp hoàn hảo giữa mắm linh, mắm sặc và nét phong phú của rau đồng cỏ dại.',
    content:
        'Bún mắm là nét chấm phá đặc sắc trong bức tranh ẩm thực miền Tây sông nước. Nước dùng được nấu từ mắm cá linh hoặc mắm cá sặc thơm nức, chắt lọc kỹ để lấy vị ngọt đậm đà mà không hề bị đắng. Một tô bún mắm đầy đủ sẽ gồm có tôm tươi, mực giòn, heo quay da giòn rụm và chả cá thát lát. Điều làm nên tâm hồn của món ăn này chính là dĩa rau sống ăn kèm phong phú với bông điên điển, kèo lèo, rau đắng và hoa súng tươi ngon.',
    categories: ['Ẩm thực'],
  ),
  Post(
    id: '13',
    title: 'Khám phá vẻ đẹp yên bình của Làng cổ Đường Lâm',
    author: 'Thái Sơn',
    date: '28/08/2026',
    summary:
        'Tìm về không gian xưa cũ với cổng làng, cây đa, bến nước và những ngôi nhà đá ong hàng trăm năm tuổi.',
    content:
        'Nằm cách trung tâm Hà Nội khoảng 40km, Làng cổ Đường Lâm vẫn giữ nguyên vẹn nét kiến trúc đặc trưng của một làng quê Bắc Bộ cổ kính. Thuê một chiếc xe đạp tản bộ qua những con ngõ nhỏ lát gạch nghiêng, ngắm nhìn những bức tường đá ong màu vàng xám rêu phong sẽ khiến bạn cảm thấy mọi xô xấp của cuộc sống hiện đại như dừng lại. Hãy ghé thăm các ngôi nhà cổ trên 300 năm tuổi và thử một ngụm trà chè lam thơm nồng vị gừng.',
    categories: ['Địa điểm'],
  ),
  Post(
    id: '14',
    title: 'Mẹo săn vé máy bay giá rẻ và đặt phòng khách sạn tối ưu chi phí',
    author: 'Khánh Linh',
    date: '26/08/2026',
    summary:
        'Những thủ thuật không thể bỏ qua giúp bạn tiết kiệm đến 40% chi phí cho mỗi chuyến đi.',
    content:
        'Để chuyến du lịch không trở thành gánh nặng tài chính, việc canh vé máy bay và đặt phòng sớm là vô cùng quan trọng. Bạn nên đăng ký nhận bản tin khuyến mãi từ các hãng hàng không, chủ động đặt vé trước từ 2-3 tháng và ưu tiên chọn các chuyến bay đêm hoặc sáng sớm. Khi đặt phòng, hãy dùng các trang web so sánh giá, tận dụng mã giảm giá của thẻ thanh toán và xem xét các homestay nằm hơi xa trung tâm một chút nhưng có tiện nghi đầy đủ.',
    categories: ['Kinh nghiệm'],
  ),
  Post(
    id: '15',
    title: 'Thưởng thức Cơm Tấm Sài Gòn: Nét văn hóa bình dân mà tinh tế',
    author: 'Quốc Bảo',
    date: '25/08/2026',
    summary:
        'Sự kết hợp hoàn hảo giữa sườn nướng mỡ hành, chả trứng, bì giòn và nước mắm kẹo ngọt.',
    content:
        'Cơm tấm từ lâu đã trở thành biểu tượng gắn liền với đời sống thường nhật của người dân Sài Gòn từ sáng sớm tới đêm muộn. Dĩa cơm tấm bốc khói nghi ngút nổi bật với miếng sườn ướp đậm đà nướng chín tới trên bếp than hồng, thêm miếng chả trứng béo ngậy, bì heo dai giòn và muỗng mỡ hành xanh mướt. Điểm nhấn quyết định độ ngon chính là chén nước mắm chua ngọt dạng kẹo sánh quyện tưới đều lên đĩa cơm.',
    categories: ['Ẩm thực', 'Kinh nghiệm'],
  ),
  Post(
    id: '16',
    title: 'Ghé thăm Đảo Lý Sơn: Vương quốc tỏi và thiên đường biển xanh',
    author: 'Ánh Dương',
    date: '23/08/2026',
    summary:
        'Trải nghiệm lặn biển ngắm san hô tại Đảo Bé và check-in Cổng Tò Vò ngắm hoàng hôn.',
    content:
        'Đảo Lý Sơn (Quảng Ngãi) hớp hồn du khách bởi vẻ đẹp hoang sơ của những trầm tích núi lửa hàng triệu năm. Hãy dành trọn một ngày đi cano ra Đảo Bé để hòa mình vào làn nước biển trong vắt tới đáy, lặn ngắm những rạn san hô đầy màu sắc. Khi chiều tà, điểm dừng chân lý tưởng nhất là Cổng Tò Vò để lưu lại những bức hình hoàng hôn tuyệt đẹp. Đừng quên mua tỏi cô đơn - đặc sản nổi tiếng của hòn đảo về làm quà nhé.',
    categories: ['Địa điểm', 'Kinh nghiệm'],
  ),
  Post(
    id: '17',
    title: 'Bánh Mì Việt Nam: Hành trình nâng tầm món ăn đường phố thế giới',
    author: 'Hoàng Yến',
    date: '20/08/2026',
    summary:
        'Khám phá sự đa dạng của nhân bánh mì từ Bắc vào Nam và lý do món ăn này gây sốt toàn cầu.',
    content:
        'Bánh mì Việt Nam là sự giao thoa văn hóa ẩm thực tuyệt vời. Ổ bánh mì giòn rụm bên ngoài, mềm xốp bên trong hòa quyện cùng lớp pate béo ngậy, thịt nguội, chả lụa, dưa góp chua ngọt và vài cọng ngò rí thanh mát. Mỗi vùng miền lại có cách sáng tạo nhân riêng: từ bánh mì que Hải Phòng, bánh mì dầm pate Hà Nội đến bánh mì phá lấu, bánh mì chả cá Sài Gòn, tạo nên sự phong phú không nơi nào có được.',
    categories: ['Ẩm thực'],
  ),
  Post(
    id: '18',
    title: 'Kinh nghiệm phượt Hà Giang mùa hoa tam giác mạch',
    author: 'Đăng Khoa',
    date: '18/08/2026',
    summary:
        'Tuyến đường chi tiết chinh phục Mã Pí Lèng, sông Nho Quế và các đồi hoa hồng rực.',
    content:
        'Mùa thu là thời điểm đẹp nhất để lên đường khám phá mảnh đất địa đầu Tổ quốc Hà Giang. Những thảm hoa tam giác mạch phủ hồng các sườn núi tạo nên khung cảnh nên thơ lạ kỳ. Hãy dành thời gian lái xe qua Đèo Mã Pí Lèng - một trong tứ đại đỉnh đèo của Việt Nam, chèo thuyền Kayak trên dòng sông Nho Quế xanh ngọc bích và ghé thăm Dinh thự họ Vương để tìm hiểu về lịch sử văn hóa độc đáo của vùng đất đá mèo này.',
    categories: ['Kinh nghiệm', 'Địa điểm', 'Ẩm thực'],
  ),
  Post(
    id: '19',
    title: 'Một ngày làm nông dân tại Làng rau Trà Quế Quảng Nam',
    author: 'Minh Trí',
    date: '15/08/2026',
    summary:
        'Trải nghiệm tự tay tưới rau, thu hoạch và thưởng thức các món ăn dân dã ngay tại vườn.',
    content:
        'Nếu muốn tìm một khoảng lặng thư thái rời xa phố thị xô xập, Làng rau Trà Quế là sự lựa chọn tuyệt vời. Tại đây, bạn sẽ được mang guốc gỗ, đội nón lá, tự tay cuốc đất, tưới những luống rau thơm bằng gầu đôi truyền thống. Sau buổi lao động hăng say, bạn sẽ được thưởng thức món Tam Hữu thơm lừng và bánh xèo tôm nhảy giòn rụm được chế biến ngay từ những nguyên liệu tươi ngon vừa thu hoạch.',
    categories: ['Địa điểm', 'Ẩm thực'],
  ),
  Post(
    id: '20',
    title:
        'Cẩm nang đi xe khách giường nằm an toàn và thoải mái cho người đi xa',
    author: 'Bảo Ngọc',
    date: '12/08/2026',
    summary:
        'Những lưu ý quan trọng về vị trí chỗ ngồi, bảo quản tài sản và phòng chống say xe.',
    content:
        'Di chuyển bằng xe khách giường nằm là lựa chọn phổ biến cho các chuyến đi đêm cự ly trung bình. Để có hành trình êm ái, bạn nên đặt chỗ ở tầng dưới, dãy giữa xe để giảm thiểu độ rung lắc. Luôn mang theo một chiếc túi nhỏ đeo bên người để đựng giấy tờ tùy thân, điện thoại và tiền mặt ngay cả khi đi ngủ. Hãy đeo khẩu trang, chuẩn bị nút tai chống ồn và uống thuốc chống say xe trước khi xuất bến 30 phút để có một giấc ngủ trọn vẹn.',
    categories: ['Kinh nghiệm'],
  ),
];
>>>>>>> 250514a1eb6d282f5bbe3449101cb137c332e346
