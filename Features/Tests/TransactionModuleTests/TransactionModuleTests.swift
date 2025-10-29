import Testing
@testable import TransactionModule

@Test
func example() async throws {
    let a = 4
    let b = 3
    let sum = a + b
    #expect(sum == 7)
}
