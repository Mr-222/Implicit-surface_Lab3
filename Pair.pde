public class Pair<K, V> {
    private K first;
    private V second;

    public Pair(K a, V b) {
        this.first = a;
        this.second = b;
    }

    public K get_first() { return first; }
    public V get_second() { return second; }
}
