/* eslint-disable no-console -- because it's a simple script */
import { execSync } from "child_process";
import fs from "fs";
import path from "path";
import process from "process";

function checkCommand(cmd, args = ["--version"]) {
	try {
		execSync(`${cmd} ${args.join(" ")}`, { stdio: "ignore" });
		return true;
	} catch {
		return false;
	}
}

function checkFileExists(file) {
	return fs.existsSync(path.resolve(process.cwd(), file));
}

const checks = [
	{
		name: "Node.js",
		passed: checkCommand("node"),
	},
	{
		name: "pnpm",
		passed: checkCommand("pnpm", ["version"]),
	},
	{
		name: ".env file",
		passed: checkFileExists(".env"),
	},
];

// Output table
console.log("\n🔍 Environment Check:\n");
for (const check of checks) {
	const status = check.passed ? "✅" : "❌";
	console.log(`${status} ${check.name}`);
}

const failed = checks.filter((check) => !check.passed);
if (failed.length > 0) {
	console.log("\n⚠️ Missing or incomplete setup:");
	for (const fail of failed) {
		console.log(` - ${fail.name}`);
	}

	process.exitCode = 1;
} else {
	console.log("\n🎉 All checks passed!");
}
