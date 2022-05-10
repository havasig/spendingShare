import 'package:tuple/tuple.dart';

void main() async {
  //SimplifyDebts().createGraphForDebts();

  // graph[i][j] indicates the amount
  // that person i needs to pay person j
  List<List<double>> graph = [
    [10, 0, 0, 0, 0, 0, 0],
    [0, 10, 40, 0, 0, 0, 0],
    [0, 0, 10, 20, 0, 0, 0],
    [0, 0, 0, 10, 50, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 10, 30, 10, 10, 0, 0],
    [0, 30, 0, 10, 0, 0, 0],
  ];

  List<List<double>> graphh = [
    [120, 20],
    [120, 20],
  ];

  // Print the solution
  GFG(2).minCashFlow(graphh);
}

// Java program to find maximum cash
// flow among a set of persons

class GFG {
  // Number of persons (or vertices in the graph)
  GFG(this.N);

  int N;

  // A utility function that returns
  // index of minimum value in arr[]
  int getMin(List<double> arr) {
    int minInd = 0;
    for (int i = 1; i < N; i++) {
      if (arr[i] < arr[minInd]) {
        minInd = i;
      }
    }
    return minInd;
  }

  // A utility function that returns
  // index of maximum value in arr[]
  int getMax(List<double> arr) {
    int maxInd = 0;
    for (int i = 1; i < N; i++) {
      if (arr[i] > arr[maxInd]) {
        maxInd = i;
      }
    }
    return maxInd;
  }

  // A utility function to return minimum of 2 values
  double minOf2(double x, double y) {
    return (x < y) ? x : y;
  }

  // amount[p] indicates the net amount
  // to be credited/debited to/from person 'p'
  // If amount[p] is positive, then
  // i'th person will amount[i]
  // If amount[p] is negative, then
  // i'th person will give -amount[i]
  minCashFlowRec(List<double> amount, List<Tuple3<int, int, double>> result) {
    // Find the indexes of minimum and
    // maximum values in amount[]
    // amount[mxCredit] indicates the maximum amount
    // to be given (or credited) to any person .
    // And amount[mxDebit] indicates the maximum amount
    // to be taken(or debited) from any person.
    // So if there is a positive value in amount[],
    // then there must be a negative value
    int mxCredit = getMax(amount), mxDebit = getMin(amount);

    // If both amounts are 0, then
    // all amounts are settled
    if (amount[mxCredit] == 0 && amount[mxDebit] == 0) {
      return;
    }

    // Find the minimum of two amounts
    double min = minOf2(-amount[mxDebit], amount[mxCredit]);
    amount[mxCredit] -= min;
    amount[mxDebit] += min;

    // If minimum is the maximum amount to be
    print("Person " + mxDebit.toString() + " pays " + min.toString() + " to " + "Person " + mxCredit.toString());

    result.add(Tuple3(mxDebit, mxCredit, min));

    // Recur for the amount array.
    // Note that it is guaranteed that
    // the recursion would terminate
    // as either amount[mxCredit] or
    // amount[mxDebit] becomes 0
    minCashFlowRec(amount, result);
  }

  // Given a set of persons as graph[]
  // where graph[i][j] indicates
  // the amount that person i needs to
  // pay person j, this function
  // finds and prints the minimum
  // cash flow to settle all debts.
  List<Tuple3<int, int, double>> minCashFlow(List<List<double>> graph) {
    // Create an array amount[],
    // initialize all value in it as 0.
    List<double> amount = List<double>.filled(N, 0);
    List<Tuple3<int, int, double>> result = [];

    // Calculate the net amount to
    // be paid to person 'p', and
    // stores it in amount[p]. The
    // value of amount[p] can be
    // calculated by subtracting
    // debts of 'p' from credits of 'p'
    for (int p = 0; p < N; p++) {
      for (int i = 0; i < N; i++) {
        amount[p] += (graph[i][p] - graph[p][i]);
      }
    }

    minCashFlowRec(amount, result);
    return result;
  }
}

// This code is contributed by Anant Agarwal.
