import 'package:re_view_front/features/category/domain/entities/product_category.dart';

const productCategoryTree = <ProductCategory>[
  ProductCategory(
    id: 'digital-appliance',
    label: '디지털/가전',
    children: [
      ProductCategory(
        id: 'mobile-tablet',
        label: '모바일/태블릿',
        children: [
          ProductCategory(id: 'smartphone', label: '스마트폰'),
          ProductCategory(id: 'tablet', label: '태블릿'),
          ProductCategory(id: 'smartwatch', label: '스마트워치'),
          ProductCategory(id: 'phone-accessory', label: '휴대폰 액세서리'),
        ],
      ),
      ProductCategory(
        id: 'pc-peripheral',
        label: 'PC/주변기기',
        children: [
          ProductCategory(id: 'laptop', label: '노트북'),
          ProductCategory(id: 'desktop', label: '데스크탑'),
          ProductCategory(id: 'monitor', label: '모니터'),
          ProductCategory(id: 'keyboard', label: '키보드'),
          ProductCategory(id: 'mouse', label: '마우스'),
          ProductCategory(id: 'storage-device', label: '저장장치'),
        ],
      ),
      ProductCategory(
        id: 'video-audio',
        label: '영상/음향',
        children: [
          ProductCategory(id: 'tv', label: 'TV'),
          ProductCategory(id: 'projector', label: '빔프로젝터'),
          ProductCategory(id: 'earphone', label: '이어폰'),
          ProductCategory(id: 'headphone', label: '헤드폰'),
          ProductCategory(id: 'speaker', label: '스피커'),
        ],
      ),
      ProductCategory(
        id: 'living-appliance',
        label: '생활가전',
        children: [
          ProductCategory(id: 'vacuum-cleaner', label: '청소기'),
          ProductCategory(id: 'air-purifier', label: '공기청정기'),
          ProductCategory(id: 'fan', label: '선풍기'),
          ProductCategory(id: 'dehumidifier', label: '제습기'),
          ProductCategory(id: 'humidifier', label: '가습기'),
        ],
      ),
      ProductCategory(
        id: 'kitchen-appliance',
        label: '주방가전',
        children: [
          ProductCategory(id: 'microwave', label: '전자레인지'),
          ProductCategory(id: 'air-fryer', label: '에어프라이어'),
          ProductCategory(id: 'coffee-machine', label: '커피머신'),
          ProductCategory(id: 'rice-cooker', label: '밥솥'),
          ProductCategory(id: 'blender', label: '믹서기'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'fashion-clothing',
    label: '패션의류',
    children: [
      ProductCategory(
        id: 'women-clothing',
        label: '여성의류',
        children: [
          ProductCategory(id: 'dress', label: '원피스'),
          ProductCategory(id: 't-shirt', label: '티셔츠'),
          ProductCategory(id: 'shirt', label: '셔츠'),
          ProductCategory(id: 'knitwear', label: '니트'),
          ProductCategory(id: 'pants', label: '팬츠'),
          ProductCategory(id: 'skirt', label: '스커트'),
          ProductCategory(id: 'outerwear', label: '아우터'),
        ],
      ),
      ProductCategory(
        id: 'men-clothing',
        label: '남성의류',
        children: [
          ProductCategory(id: 'men-t-shirt', label: '티셔츠'),
          ProductCategory(id: 'men-shirt', label: '셔츠'),
          ProductCategory(id: 'men-knitwear', label: '니트'),
          ProductCategory(id: 'men-pants', label: '팬츠'),
          ProductCategory(id: 'suit', label: '정장'),
          ProductCategory(id: 'men-outerwear', label: '아우터'),
        ],
      ),
      ProductCategory(
        id: 'underwear-homewear',
        label: '언더웨어/홈웨어',
        children: [
          ProductCategory(id: 'underwear', label: '속옷'),
          ProductCategory(id: 'pajamas', label: '잠옷'),
          ProductCategory(id: 'homewear', label: '실내복'),
          ProductCategory(id: 'socks', label: '양말'),
        ],
      ),
      ProductCategory(
        id: 'sports-clothing',
        label: '스포츠의류',
        children: [
          ProductCategory(id: 'training-wear', label: '트레이닝복'),
          ProductCategory(id: 'leggings', label: '레깅스'),
          ProductCategory(id: 'functional-clothing', label: '기능성 의류'),
          ProductCategory(id: 'swimwear', label: '수영복'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'fashion-accessory',
    label: '패션잡화',
    children: [
      ProductCategory(
        id: 'shoes',
        label: '신발',
        children: [
          ProductCategory(id: 'sneakers', label: '스니커즈'),
          ProductCategory(id: 'dress-shoes', label: '구두'),
          ProductCategory(id: 'sandals', label: '샌들'),
          ProductCategory(id: 'boots', label: '부츠'),
          ProductCategory(id: 'slippers', label: '슬리퍼'),
        ],
      ),
      ProductCategory(
        id: 'bags',
        label: '가방',
        children: [
          ProductCategory(id: 'backpack', label: '백팩'),
          ProductCategory(id: 'shoulder-bag', label: '숄더백'),
          ProductCategory(id: 'tote-bag', label: '토트백'),
          ProductCategory(id: 'cross-bag', label: '크로스백'),
          ProductCategory(id: 'carrier', label: '캐리어'),
        ],
      ),
      ProductCategory(
        id: 'wallet-belt',
        label: '지갑/벨트',
        children: [
          ProductCategory(id: 'bi-fold-wallet', label: '반지갑'),
          ProductCategory(id: 'long-wallet', label: '장지갑'),
          ProductCategory(id: 'card-wallet', label: '카드지갑'),
          ProductCategory(id: 'belt', label: '벨트'),
        ],
      ),
      ProductCategory(
        id: 'accessory',
        label: '액세서리',
        children: [
          ProductCategory(id: 'hat', label: '모자'),
          ProductCategory(id: 'watch', label: '시계'),
          ProductCategory(id: 'sunglasses', label: '선글라스'),
          ProductCategory(id: 'jewelry', label: '주얼리'),
          ProductCategory(id: 'muffler', label: '머플러'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'beauty',
    label: '뷰티',
    children: [
      ProductCategory(
        id: 'skincare',
        label: '스킨케어',
        children: [
          ProductCategory(id: 'skin-toner', label: '스킨/토너'),
          ProductCategory(id: 'essence', label: '에센스'),
          ProductCategory(id: 'cream', label: '크림'),
          ProductCategory(id: 'suncare', label: '선케어'),
          ProductCategory(id: 'mask-pack', label: '마스크팩'),
        ],
      ),
      ProductCategory(
        id: 'makeup',
        label: '메이크업',
        children: [
          ProductCategory(id: 'base-makeup', label: '베이스'),
          ProductCategory(id: 'lip-makeup', label: '립'),
          ProductCategory(id: 'eye-makeup', label: '아이'),
          ProductCategory(id: 'cheek-makeup', label: '치크'),
          ProductCategory(id: 'nail', label: '네일'),
        ],
      ),
      ProductCategory(
        id: 'cleansing',
        label: '클렌징',
        children: [
          ProductCategory(id: 'cleansing-foam', label: '클렌징폼'),
          ProductCategory(id: 'cleansing-oil', label: '클렌징오일'),
          ProductCategory(id: 'remover', label: '리무버'),
        ],
      ),
      ProductCategory(
        id: 'haircare',
        label: '헤어케어',
        children: [
          ProductCategory(id: 'shampoo', label: '샴푸'),
          ProductCategory(id: 'treatment', label: '트리트먼트'),
          ProductCategory(id: 'hair-essence', label: '헤어에센스'),
          ProductCategory(id: 'hair-dye', label: '염색약'),
        ],
      ),
      ProductCategory(
        id: 'bodycare',
        label: '바디케어',
        children: [
          ProductCategory(id: 'body-wash', label: '바디워시'),
          ProductCategory(id: 'body-lotion', label: '바디로션'),
          ProductCategory(id: 'hand-foot-care', label: '핸드/풋케어'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'food',
    label: '식품',
    children: [
      ProductCategory(
        id: 'fresh-food',
        label: '신선식품',
        children: [
          ProductCategory(id: 'fruit', label: '과일'),
          ProductCategory(id: 'vegetable', label: '채소'),
          ProductCategory(id: 'meat', label: '정육'),
          ProductCategory(id: 'seafood', label: '수산'),
          ProductCategory(id: 'egg-dairy', label: '계란/유제품'),
        ],
      ),
      ProductCategory(
        id: 'processed-food',
        label: '가공식품',
        children: [
          ProductCategory(id: 'instant-food', label: '즉석식품'),
          ProductCategory(id: 'canned-food', label: '통조림'),
          ProductCategory(id: 'noodle', label: '면류'),
          ProductCategory(id: 'sauce-seasoning', label: '소스/양념'),
        ],
      ),
      ProductCategory(
        id: 'snack-dessert',
        label: '간식/디저트',
        children: [
          ProductCategory(id: 'snack', label: '과자'),
          ProductCategory(id: 'chocolate', label: '초콜릿'),
          ProductCategory(id: 'bread', label: '빵'),
          ProductCategory(id: 'rice-cake', label: '떡'),
          ProductCategory(id: 'ice-cream', label: '아이스크림'),
        ],
      ),
      ProductCategory(
        id: 'beverage',
        label: '음료',
        children: [
          ProductCategory(id: 'water', label: '생수'),
          ProductCategory(id: 'coffee', label: '커피'),
          ProductCategory(id: 'tea', label: '차'),
          ProductCategory(id: 'soda', label: '탄산'),
          ProductCategory(id: 'juice', label: '주스'),
        ],
      ),
      ProductCategory(
        id: 'health-food',
        label: '건강식품',
        children: [
          ProductCategory(id: 'supplement', label: '영양제'),
          ProductCategory(id: 'protein', label: '단백질'),
          ProductCategory(id: 'red-ginseng', label: '홍삼'),
          ProductCategory(id: 'probiotics', label: '유산균'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'living-kitchen',
    label: '생활/주방',
    children: [
      ProductCategory(
        id: 'daily-supplies',
        label: '생활용품',
        children: [
          ProductCategory(id: 'detergent', label: '세제'),
          ProductCategory(id: 'tissue', label: '휴지'),
          ProductCategory(id: 'cleaning-supplies', label: '청소용품'),
          ProductCategory(id: 'bathroom-supplies', label: '욕실용품'),
        ],
      ),
      ProductCategory(
        id: 'kitchenware',
        label: '주방용품',
        children: [
          ProductCategory(id: 'pot', label: '냄비'),
          ProductCategory(id: 'frying-pan', label: '프라이팬'),
          ProductCategory(id: 'knife-cutting-board', label: '칼/도마'),
          ProductCategory(id: 'tableware', label: '식기'),
          ProductCategory(id: 'storage-container', label: '보관용기'),
        ],
      ),
      ProductCategory(
        id: 'storage-organization',
        label: '수납/정리',
        children: [
          ProductCategory(id: 'living-box', label: '리빙박스'),
          ProductCategory(id: 'hanger', label: '옷걸이'),
          ProductCategory(id: 'shelf', label: '선반'),
          ProductCategory(id: 'compression-bag', label: '압축팩'),
        ],
      ),
      ProductCategory(
        id: 'safety-tools',
        label: '안전/공구',
        children: [
          ProductCategory(id: 'tool', label: '공구'),
          ProductCategory(id: 'power-strip', label: '멀티탭'),
          ProductCategory(id: 'security-supplies', label: '방범용품'),
          ProductCategory(id: 'disaster-supplies', label: '재난용품'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'furniture-interior',
    label: '가구/인테리어',
    children: [
      ProductCategory(
        id: 'furniture',
        label: '가구',
        children: [
          ProductCategory(id: 'bed', label: '침대'),
          ProductCategory(id: 'sofa', label: '소파'),
          ProductCategory(id: 'desk', label: '책상'),
          ProductCategory(id: 'chair', label: '의자'),
          ProductCategory(id: 'cabinet', label: '수납장'),
        ],
      ),
      ProductCategory(
        id: 'bedding',
        label: '침구',
        children: [
          ProductCategory(id: 'blanket', label: '이불'),
          ProductCategory(id: 'pillow', label: '베개'),
          ProductCategory(id: 'mattress-cover', label: '매트리스커버'),
          ProductCategory(id: 'topper', label: '토퍼'),
        ],
      ),
      ProductCategory(
        id: 'home-deco',
        label: '홈데코',
        children: [
          ProductCategory(id: 'lighting', label: '조명'),
          ProductCategory(id: 'curtain', label: '커튼'),
          ProductCategory(id: 'rug', label: '러그'),
          ProductCategory(id: 'frame', label: '액자'),
          ProductCategory(id: 'clock', label: '시계'),
        ],
      ),
      ProductCategory(
        id: 'diy-construction',
        label: 'DIY/시공',
        children: [
          ProductCategory(id: 'wallpaper', label: '벽지'),
          ProductCategory(id: 'flooring', label: '바닥재'),
          ProductCategory(id: 'paint', label: '페인트'),
          ProductCategory(id: 'handle', label: '손잡이'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'sports-leisure',
    label: '스포츠/레저',
    children: [
      ProductCategory(
        id: 'health-yoga',
        label: '헬스/요가',
        children: [
          ProductCategory(id: 'dumbbell', label: '덤벨'),
          ProductCategory(id: 'mat', label: '매트'),
          ProductCategory(id: 'exercise-equipment', label: '운동기구'),
          ProductCategory(id: 'protective-gear', label: '보호대'),
        ],
      ),
      ProductCategory(
        id: 'hiking-camping',
        label: '등산/캠핑',
        children: [
          ProductCategory(id: 'tent', label: '텐트'),
          ProductCategory(id: 'sleeping-bag', label: '침낭'),
          ProductCategory(id: 'camping-furniture', label: '캠핑가구'),
          ProductCategory(id: 'hiking-shoes', label: '등산화'),
        ],
      ),
      ProductCategory(
        id: 'bicycle-board',
        label: '자전거/보드',
        children: [
          ProductCategory(id: 'bicycle', label: '자전거'),
          ProductCategory(id: 'helmet', label: '헬멧'),
          ProductCategory(id: 'protective-equipment', label: '보호장비'),
          ProductCategory(id: 'kickboard', label: '킥보드'),
        ],
      ),
      ProductCategory(
        id: 'golf',
        label: '골프',
        children: [
          ProductCategory(id: 'golf-club', label: '골프클럽'),
          ProductCategory(id: 'golf-ball', label: '골프공'),
          ProductCategory(id: 'golf-wear', label: '골프웨어'),
          ProductCategory(id: 'rangefinder', label: '거리측정기'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'car-tools',
    label: '자동차/공구',
    children: [
      ProductCategory(
        id: 'car-supplies',
        label: '자동차용품',
        children: [
          ProductCategory(id: 'car-charger', label: '차량용 충전기'),
          ProductCategory(id: 'car-holder', label: '거치대'),
          ProductCategory(id: 'car-air-freshener', label: '방향제'),
          ProductCategory(id: 'car-wash-supplies', label: '세차용품'),
        ],
      ),
      ProductCategory(
        id: 'motorcycle-supplies',
        label: '오토바이용품',
        children: [
          ProductCategory(id: 'motorcycle-helmet', label: '헬멧'),
          ProductCategory(id: 'motorcycle-gloves', label: '장갑'),
          ProductCategory(id: 'motorcycle-protector', label: '보호장비'),
          ProductCategory(id: 'motorcycle-accessory', label: '액세서리'),
        ],
      ),
      ProductCategory(
        id: 'industrial-tools',
        label: '공구/산업용품',
        children: [
          ProductCategory(id: 'power-tool', label: '전동공구'),
          ProductCategory(id: 'hand-tool', label: '수공구'),
          ProductCategory(id: 'workwear', label: '작업복'),
          ProductCategory(id: 'measuring-instrument', label: '측정기'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'baby-kids',
    label: '출산/유아동',
    children: [
      ProductCategory(
        id: 'birth-childcare',
        label: '출산/육아',
        children: [
          ProductCategory(id: 'diaper', label: '기저귀'),
          ProductCategory(id: 'baby-formula', label: '분유'),
          ProductCategory(id: 'baby-bottle', label: '젖병'),
          ProductCategory(id: 'stroller', label: '유모차'),
          ProductCategory(id: 'car-seat', label: '카시트'),
        ],
      ),
      ProductCategory(
        id: 'baby-supplies',
        label: '유아용품',
        children: [
          ProductCategory(id: 'baby-food', label: '이유식'),
          ProductCategory(id: 'baby-bath-supplies', label: '목욕용품'),
          ProductCategory(id: 'baby-safety-supplies', label: '안전용품'),
          ProductCategory(id: 'baby-bedding', label: '침구'),
        ],
      ),
      ProductCategory(
        id: 'kids-clothing',
        label: '유아동 의류',
        children: [
          ProductCategory(id: 'baby-clothing', label: '베이비의류'),
          ProductCategory(id: 'children-clothing', label: '아동의류'),
          ProductCategory(id: 'children-shoes', label: '아동신발'),
        ],
      ),
      ProductCategory(
        id: 'toys-education',
        label: '장난감/교구',
        children: [
          ProductCategory(id: 'block-toy', label: '블록'),
          ProductCategory(id: 'doll', label: '인형'),
          ProductCategory(id: 'board-game', label: '보드게임'),
          ProductCategory(id: 'educational-toy', label: '학습완구'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'pet',
    label: '반려동물',
    children: [
      ProductCategory(
        id: 'dog-supplies',
        label: '강아지용품',
        children: [
          ProductCategory(id: 'dog-food', label: '사료'),
          ProductCategory(id: 'dog-snack', label: '간식'),
          ProductCategory(id: 'dog-potty-supplies', label: '배변용품'),
          ProductCategory(id: 'dog-harness', label: '하네스'),
          ProductCategory(id: 'dog-toy', label: '장난감'),
        ],
      ),
      ProductCategory(
        id: 'cat-supplies',
        label: '고양이용품',
        children: [
          ProductCategory(id: 'cat-food', label: '사료'),
          ProductCategory(id: 'cat-snack', label: '간식'),
          ProductCategory(id: 'cat-litter', label: '모래'),
          ProductCategory(id: 'cat-tower', label: '캣타워'),
          ProductCategory(id: 'cat-toy', label: '장난감'),
        ],
      ),
      ProductCategory(
        id: 'small-pet-aquarium',
        label: '소동물/어항',
        children: [
          ProductCategory(id: 'hamster-supplies', label: '햄스터용품'),
          ProductCategory(id: 'bird-supplies', label: '새용품'),
          ProductCategory(id: 'aquarium', label: '어항'),
          ProductCategory(id: 'small-pet-food', label: '사료'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'book-stationery-hobby',
    label: '도서/문구/취미',
    children: [
      ProductCategory(
        id: 'book',
        label: '도서',
        children: [
          ProductCategory(id: 'novel', label: '소설'),
          ProductCategory(id: 'self-development', label: '자기계발'),
          ProductCategory(id: 'business-economy', label: '경제경영'),
          ProductCategory(id: 'children-book', label: '아동도서'),
          ProductCategory(id: 'reference-book', label: '참고서'),
        ],
      ),
      ProductCategory(
        id: 'stationery-office',
        label: '문구/사무',
        children: [
          ProductCategory(id: 'writing-instrument', label: '필기구'),
          ProductCategory(id: 'notebook', label: '노트'),
          ProductCategory(id: 'file-folder', label: '파일'),
          ProductCategory(id: 'office-equipment', label: '사무기기'),
        ],
      ),
      ProductCategory(
        id: 'hobby',
        label: '취미',
        children: [
          ProductCategory(id: 'instrument', label: '악기'),
          ProductCategory(id: 'art-supplies', label: '미술용품'),
          ProductCategory(id: 'plastic-model', label: '프라모델'),
          ProductCategory(id: 'collectibles', label: '수집품'),
        ],
      ),
      ProductCategory(
        id: 'ticket-goods',
        label: '티켓/굿즈',
        children: [
          ProductCategory(id: 'concert-ticket', label: '공연티켓'),
          ProductCategory(id: 'character-goods', label: '캐릭터굿즈'),
          ProductCategory(id: 'fan-goods', label: '팬굿즈'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'travel-service',
    label: '여행/서비스',
    children: [
      ProductCategory(
        id: 'travel-supplies',
        label: '여행용품',
        children: [
          ProductCategory(id: 'suitcase', label: '캐리어'),
          ProductCategory(id: 'pouch', label: '파우치'),
          ProductCategory(id: 'neck-pillow', label: '목베개'),
          ProductCategory(id: 'adapter', label: '어댑터'),
        ],
      ),
      ProductCategory(
        id: 'accommodation-ticket',
        label: '숙박/티켓',
        children: [
          ProductCategory(id: 'hotel', label: '호텔'),
          ProductCategory(id: 'pension', label: '펜션'),
          ProductCategory(id: 'admission-ticket', label: '입장권'),
          ProductCategory(id: 'experience-ticket', label: '체험권'),
        ],
      ),
      ProductCategory(
        id: 'rental-subscription',
        label: '렌탈/구독',
        children: [
          ProductCategory(id: 'appliance-rental', label: '가전렌탈'),
          ProductCategory(id: 'regular-delivery', label: '정기배송'),
          ProductCategory(id: 'life-subscription', label: '생활구독'),
        ],
      ),
    ],
  ),
  ProductCategory(
    id: 'luxury-brand',
    label: '명품/브랜드',
    children: [
      ProductCategory(
        id: 'luxury-accessory',
        label: '명품잡화',
        children: [
          ProductCategory(id: 'luxury-bag', label: '명품가방'),
          ProductCategory(id: 'luxury-wallet', label: '명품지갑'),
          ProductCategory(id: 'luxury-watch', label: '명품시계'),
        ],
      ),
      ProductCategory(
        id: 'brand-fashion',
        label: '브랜드패션',
        children: [
          ProductCategory(id: 'designer-clothing', label: '디자이너의류'),
          ProductCategory(id: 'brand-shoes', label: '브랜드신발'),
          ProductCategory(id: 'brand-accessory', label: '브랜드잡화'),
        ],
      ),
      ProductCategory(
        id: 'premium-beauty',
        label: '프리미엄뷰티',
        children: [
          ProductCategory(id: 'premium-cosmetics', label: '고가화장품'),
          ProductCategory(id: 'perfume', label: '향수'),
          ProductCategory(id: 'beauty-device', label: '뷰티기기'),
        ],
      ),
    ],
  ),
];

final productCategoryLabels = productCategoryTree.flattenLabels();
