class NumberUtil {

  // 在一个数组中取5个数，分别是第一个数，第一个中间数，中间数，最后一个中间数，最后一个数
  static List<int> getNumbers(int maxValue) {
    List<int> arr = List.generate(maxValue + 1, (index) => index);
    int midIndex = (arr.length / 2).floor();
    int firstMidIndex = (midIndex / 2).floor();
    int lastMidIndex = midIndex + (arr.length - midIndex) ~/ 2;

    List<int> indices = [
      0,
      firstMidIndex,
      midIndex,
      lastMidIndex,
      arr.length - 1
    ];
    List<int> result = indices.map((index) => arr[index]).toList();

    return result;
  }

}
