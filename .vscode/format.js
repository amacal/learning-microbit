const fs = require("fs");

if (process.argv.length < 3) {
    console.error("Usage: node format.js <file.s>");
    process.exit(1);
}

const path = process.argv[2];
const lines = fs.readFileSync(path, "utf8").split("\n");

const reformatted = lines.map((line, idx) => {
    const trimmed = line.trim();
    const assembly = trimmed.match(/^(\w+)\s+(.*)$/);

    if (trimmed === "") {
        return "";
    }

    if (trimmed.startsWith(".")) {
        return trimmed;
    }

    if (trimmed.startsWith("//") && lines[idx + 1].startsWith(".")) {
        return trimmed;
    }

    if (trimmed.startsWith("//")) {
        return `    ${trimmed}`;
    }

    if (assembly) {
        const [_, opcode, rest] = assembly;
        const index = rest.indexOf("//");

        let operands = rest;
        let comment = "";

        if (index !== -1) {
            operands = rest.slice(0, index).trim();
            comment = rest.slice(index);
        }

        const formattedOpcode = opcode.toLowerCase().padEnd(8);
        const lineWithoutComment = `    ${formattedOpcode} ${operands.toLowerCase()}`;
        const commentPadding = Math.max(0, 40 - lineWithoutComment.length);

        return `${lineWithoutComment}${" ".repeat(commentPadding)}${comment}`
    }

    return line;
});

fs.writeFileSync(path, reformatted.join("\n"), "utf8");
