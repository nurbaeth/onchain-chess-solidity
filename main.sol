// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract OnchainChess {
    enum PieceType { None, Pawn, Rook, Knight, Bishop, Queen, King }
    enum Color { None, White, Black }

    struct Piece {
        PieceType pieceType;
        Color color;
    }

    // 8x8 board: board[row][col]
    Piece[8][8] public board;

    address public whitePlayer;
    address public blackPlayer;
    Color public turn;

    constructor(address _blackPlayer) {
        whitePlayer = msg.sender;
        blackPlayer = _blackPlayer;
        turn = Color.White;
        setupBoard();
    }

    function setupBoard() internal {
        // Setup pawns
        for (uint8 i = 0; i < 8; i++) {
            board[1][i] = Piece(PieceType.Pawn, Color.White);
            board[6][i] = Piece(PieceType.Pawn, Color.Black);
        }

        // Setup rooks
        board[0][0] = Piece(PieceType.Rook, Color.White);
        board[0][7] = Piece(PieceType.Rook, Color.White);
        board[7][0] = Piece(PieceType.Rook, Color.Black);
        board[7][7] = Piece(PieceType.Rook, Color.Black);

        // Knights
        board[0][1] = Piece(PieceType.Knight, Color.White);
        board[0][6] = Piece(PieceType.Knight, Color.White);
        board[7][1] = Piece(PieceType.Knight, Color.Black);
        board[7][6] = Piece(PieceType.Knight, Color.Black);

        // Bishops
        board[0][2] = Piece(PieceType.Bishop, Color.White);
        board[0][5] = Piece(PieceType.Bishop, Color.White);
        board[7][2] = Piece(PieceType.Bishop, Color.Black);
        board[7][5] = Piece(PieceType.Bishop, Color.Black);

        // Queens
        board[0][3] = Piece(PieceType.Queen, Color.White);
        board[7][3] = Piece(PieceType.Queen, Color.Black);

        // Kings
        board[0][4] = Piece(PieceType.King, Color.White);
        board[7][4] = Piece(PieceType.King, Color.Black);
    }

    function move(uint8 fromRow, uint8 fromCol, uint8 toRow, uint8 toCol) public {
        require(fromRow < 8 && fromCol < 8 && toRow < 8 && toCol < 8, "Invalid position");
        Piece memory movingPiece = board[fromRow][fromCol];
        require(movingPiece.color == turn, "Not your turn");
        require(movingPiece.pieceType != PieceType.None, "No piece");

        if (turn == Color.White) {
            require(msg.sender == whitePlayer, "Not White");
        } else {
            require(msg.sender == blackPlayer, "Not Black");
        }

        // Simple movement without full rules
        board[toRow][toCol] = movingPiece;
        board[fromRow][fromCol] = Piece(PieceType.None, Color.None);

        // Switch turn
        turn = turn == Color.White ? Color.Black : Color.White;
    }

    function getPiece(uint8 row, uint8 col) public view returns (PieceType, Color) {
        require(row < 8 && col < 8, "Invalid position");
        Piece memory p = board[row][col];
        return (p.pieceType, p.color);
    }
}
