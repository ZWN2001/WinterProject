//overflow: TextOverflow.ellipsis的缺陷是碰到长字母、
//数字串时会整体省略而不会末尾省略，所以通过在字符串中
//间插入零宽空格来解决
class BreakWord {

  static String breakWord(String word) {
    if (word == null || word.isEmpty) {
      return word;
    } else {
      String breakWord = ' ';
      word.runes.forEach((element) {
        breakWord += String.fromCharCode(element);
        breakWord += '\u200B';
      });
      return breakWord;
    }
  }

}