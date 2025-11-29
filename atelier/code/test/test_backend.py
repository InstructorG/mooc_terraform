from backend.lambda_function import read_proverbs


def test_generation_function():
    # Given
    proverb = None

    # When
    proverb = read_proverbs()

    # Then
    assert proverb is not None